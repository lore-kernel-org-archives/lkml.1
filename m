Return-Path: <linux-kernel-owner+w=401wt.eu-S1764664AbXGWIwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764664AbXGWIwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXGWIv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:51:58 -0400
Received: from gw.goop.org ([64.81.55.164]:33432 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbXGWIv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:51:57 -0400
Message-ID: <46A46BF9.6010906@goop.org>
Date: Mon, 23 Jul 2007 01:51:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>, g3vbv@blueyonder.co.uk,
       nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc>
In-Reply-To: <46A3FBB7.9000608@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> on Mon, 23 Jul 2007 01:47:30 +0200, /me wrote:
>   
>> On my test machine with a Pentium D 940 processor, Intel DQ965GF
>> mainboard and SATA disks, kernel 2.6.22-git17 (32 bit build) fails
>> to come up because it cannot find the disk drives. Same issue
>> with a clone of the 'linus' git tree. Anything known?
>>     
>
> Ok, scrap this. Turns out it wasn't a good idea to answer 'Y' to
> the new XEN config option during "make oldconfig". After changing
> it to CONFIG_XEN=n, all's well again. Sorry for the noise.
>   

That seems very unlikely.  If you're booting a Xen-enabled kernel on
bare hardware, the Xen code should have no effect at all.  It certainly
shouldn't prevent you from probing devices.

Could you send me your .config and dmesg output?  Are you saying that
leaving PARAVIRT enabled but XEN disabled will allow your system to
boot?  What happens if you enable VMI and/or LGUEST?

Thanks,
    J
