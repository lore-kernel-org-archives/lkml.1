Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZIRNym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZIRNym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZIRNyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:54:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38714 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZIRNyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:54:41 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 06:54:39 -0700
In-Reply-To: <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com> (Kay Sievers's message of "Thu\, 17 Sep 2009 14\:03\:09 +0200")
Message-ID: <m1d45oxsrk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs  maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't understand. Udev applies the final policy including
> permissions/ownership, just as before. There is no differrence. It's
> just that you can bring up a box without complex userspace to
> bootstrap /dev. And that's a big win on its own.

udev is too complex to use?  That sounds like a userspace bug.

This I guess is where I am baffled.   The argument for devtmpfs
always seem to boil down to: udev sucks let's write some kernel
code instead.

I have been trying to ask for a long time why we can't just fix
udev to not suck. 

>  And things like
> "modprobe loop; losetup /dev/loop0" will just work, which it doesn't
> with todays async udev. Again, please make yourself familiar how
> things work, and what the problems are.

I guess I don't understand why 
modprobe loop; losetup /dev/loop0 is an interesting case.
When you can just as easily do:
modprobe loop; udevadm settle; losetup /dev/loop0.

Eric
