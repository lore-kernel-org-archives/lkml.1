Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZLTMa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZLTMa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZLTMaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:30:55 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62426 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZLTMaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KxHKGJA1sYoFMIEwkpAoSQsyENSJi1Hzs8Qw/zwk7Bq6d47MQ+VYX9exaD3mN6oiRh
         6i/J1s2uupGEePYeb3DLOl0OesA0cu1Eissm4b7nfNTbEkfy77WPNKFx9wqNQfSxDBT2
         PxEQ9NWduubR9N00ZpunyDG/nLb5YqafIZCGU=
MIME-Version: 1.0
In-Reply-To: <4B2E1241.9070503@xs4all.nl>
References: <4B2E1241.9070503@xs4all.nl>
Date: Sun, 20 Dec 2009 15:30:52 +0300
Message-ID: <a4423d670912200430v244f7ae0oc48af2168c96bef1@mail.gmail.com>
Subject: Re: Stable version 2.6.32.2 broke my KMS Radeon setup
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Ruud Linders <kernelml@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/20 Ruud Linders <kernelml@xs4all.nl>:
>
> Hello,
>
> After upgrading from 2.6.32.1 to 2.6.32.2 my radeon KMS broke. Broke
> meaning after kernel boot at the moment radeon module is loaded, I get a
> blank screen, monitor goes in powersave mode and machine stops booting
> (ping-able but can't login via ssh and nothing in the logs after
> Sysrq-S-U-B reboot).
>
> Upgraded userspace  (drm/mesa/xf86-video-ati) to git version from
> 19-december but no change.
>
> Note this happens on 2 different systems, both connected via DVI-D to an
> LCD monitor:
>  Chipset: "ATI RV730XT [Radeon HD 4670]" (ChipID = 0x9490)
> and
>  Chipset: "ATI Radeon HD 3200 Graphics" (ChipID = 0x9610)
>
> So I started looking at the diff between 2.6.32.1 & 2.6.32.2, backing
> out attached change makes everything work again. Anything else I can
> provide to debug/fix this, let me know.
>

Add CC's
