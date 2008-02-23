Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbYBWSwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbYBWSwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYBWSwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:52:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:12214 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYBWSwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dBUGYNfsT3qDmd5B0GIOKDQtIVd96eVR+9IsqOqMDaaUsPbftvEJNQn6blynIbqIHi2xHeQss9iYPFTkJ4WkZ4bh76ge+BdV5Orx3VpX/hdtcniPE5ojzasj3zi1gVTQTwihOLChrZYimhzB9tLbxNkI1CqnUk3SKyURo7C/sJU=
Message-ID: <19f34abd0802231052x926c873p3ceef7904a120087@mail.gmail.com>
Date: Sat, 23 Feb 2008 19:52:38 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Cc: "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080223183138.59d18e26@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
	 <20080223183138.59d18e26@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 7:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> O> I don't see the connection between (no-)smp and ata. Something with
>
> > interrupt routing/IPI, missing irq ack? Booting another !SMP kernel
>  > works fine. The problem also exists in 2.6.24-rc2.
>
>  Almost certainly interrupt routing try smp but with noapic and see if it
>  fails as well ?

noapic works fine.


V
