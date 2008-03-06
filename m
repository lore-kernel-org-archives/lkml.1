Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYCFR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYCFR3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYCFR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:28:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYCFR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:28:54 -0500
Message-ID: <47D0271F.4070705@zytor.com>
Date: Thu, 06 Mar 2008 09:17:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Jakub Jelinek <jakub@redhat.com>, NightStrike <nightstrike@gmail.com>,
       Olivier Galibert <galibert@pobox.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>	 <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>	 <6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com>	 <47D012B4.3020104@zytor.com>	 <20080306162353.GF24887@devserv.devel.redhat.com>	 <6dc9ffc80803060858i7d4e8b56o99ff8ad301a5cc1a@mail.gmail.com>	 <47D024AA.9010300@zytor.com> <6dc9ffc80803060914x187049a2hb24ef501baf55601@mail.gmail.com>
In-Reply-To: <6dc9ffc80803060914x187049a2hb24ef501baf55601@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.J. Lu wrote:
>>
>>  Not a fix, an (optional) workaround for a system bug.
> 
> So that is the bug in the Linux kernel. Since fixing kernel is much easier
> than providing a workaround in compilers, I think kernel should be fixed
> and no need for icc/gcc fix.
> 

The problem is, you're going to have to be able to produce binaries 
compatible with old kernels for a *long* time for come.  Are you 
honestly saying you'll tell those people "use gcc 4.2 or earlier"?  If 
so, I think most distros will have to freeze gcc for the next several years.

	-hpa
