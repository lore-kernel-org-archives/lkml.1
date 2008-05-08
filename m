Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYEHN0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYEHN0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYEHN0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:26:40 -0400
Received: from rtr.ca ([76.10.145.34]:3799 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbYEHN0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:26:38 -0400
Message-ID: <4822FF8D.7020805@rtr.ca>
Date: Thu, 08 May 2008 09:26:37 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: =?UTF-8?B?U3TDqXBoYW5lIEFOQ0VMT1Q=?= <sancelot@free.fr>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux IDE <linux-ide@vger.kernel.org>, Jeff Woods <jeff@jeffwoods.us>
Subject: Re: Compact Flash Question
References: <48215673.3060201@wpkg.org>	 <e2e108260805070044v42f596bbj39c5b52b6f0a096@mail.gmail.com>	 <48216039.3070001@wpkg.org> <4821A12F.2020800@aitel.hist.no>	 <4821C462.2000108@free.fr> <e2e108260805070946t63f35e36q6960bdff11fecd8c@mail.gmail.com>
In-Reply-To: <e2e108260805070946t63f35e36q6960bdff11fecd8c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Wed, May 7, 2008 at 5:01 PM, Stéphane ANCELOT <sancelot@free.fr> wrote:
>> we use  silicon systems CF  with wear leveling inside  , we write a few
>> kb data back each 1/4 h  on it.(log /tmp files  are redirected to ram)
> 
> Silicon Systems CompactFlashes are the among the most reliable
> CompactFlashes I have used in embedded devices. See also
> http://www.siliconsystems.com/silicondrive/whitepapers/SSWP03-Endurance-R.pdf
> for a whitepaper that explains their wear leveling and error
> correction algorithms. Furthermore, Silicon Systems has a technology
> called SiSMART that allows to monitor by how far the CompactFlash is
> worn out, such that it can be monitored whether or not it is time to
> replace the CompactFlash. (Note: I am not affiliated in any way to
> Silicon Systems.)
..

Mmm.. according to that document, the "dynamic wear leveling" devices
might benefit from having Linux issue CF-Erase commands to unallocated sectors,
so that the onboard CF controller can then add those sectors to the wear-leveling
rotation scheme.

There was discussion at LSF'08 about possible filesystem hooks that could
be used for this (and other) purposes when deleting files.

Cheers
