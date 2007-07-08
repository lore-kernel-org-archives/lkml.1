Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXGHN3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXGHN3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbXGHN3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:29:24 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:39944 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXGHN3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:29:24 -0400
Message-ID: <4690E65B.5050607@gentoo.org>
Date: Sun, 08 Jul 2007 09:27:55 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org> <20070630154230.4ad373fa.akpm@linux-foundation.org>
In-Reply-To: <20070630154230.4ad373fa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 30 Jun 2007 18:25:31 -0400 Daniel Drake <dsd@gentoo.org> wrote:
>> This patch solves a 2.6.20.11 (and 2.6.21) regression added by the patch 
>> titled "x86: Don't probe for DDC on VBE1.2"
>>
>> The regression caused the screen resolution to be incorrectly adjusted 
>> by 6 pixels. This patch makes it go back to normal again.
>>
>> https://bugs.gentoo.org/show_bug.cgi?id=181067
>>
>> Please apply this patch or discuss further :)
> 
> Well drat.  I didn't merge the patch because it conflicts with
> git-newsetup, and Peter believes that git-newsetup already contains an
> equivalent fix.  Testing 2.6.22-rc6-mm1 would confirm that.  Please.

2.6.22-rc6-mm1 has the same problem (it is not fixed there).

Daniel
