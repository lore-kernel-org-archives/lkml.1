Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbXLETaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbXLETaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXLETaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:30:06 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47309 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXLETaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:30:04 -0500
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
	<Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
From: Nix <nix@esperi.org.uk>
Emacs: featuring the world's first municipal garbage collector!
Date: Wed, 05 Dec 2007 19:29:36 +0000
In-Reply-To: <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "1 Dec 2007 12:10:25 -0000")
Message-ID: <87tzmxym73.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Dec 2007, Jan Engelhardt uttered the following:

>
> On Dec 1 2007 06:19, Justin Piszcz wrote:
>
>> RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>> you use 1.x superblocks with LILO you can't boot)
>
> Says who? (Don't use LILO ;-)

Well, your kernels must be on a 0.90-superblocked RAID-0 or RAID-1
device. It can't handle booting off 1.x superblocks nor RAID-[56]
(not that I could really hope for the latter).

But that's just /boot, not everything else.

>>
>> Not using ANY initramfs/initrd images, everything is compiled into 1 
>> kernel image (makes things MUCH simpler and the expected device layout 
>> etc is always the same, unlike initrd/etc).
>>
> My expected device layout is also always the same, _with_ initrd. Why? 
> Simply because mdadm.conf is copied to the initrd, and mdadm will 
> use your defined order.

Of course the same is true of initramfs, which can give you the 1 kernel
image back, too. (It's also nicer in that you can autoassemble
e.g. LVM-on-RAID, or even LVM-on-RAID-over-nbd if you so desire.)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
