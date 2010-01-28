Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713Ab0A1P5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0A1P5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662Ab0A1P5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:57:55 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:48190 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0A1P5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:57:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=AJXMAJshXRTWo5rVtz19rmHPmdJg+hR9pidSLwOcsc3afR9JI9gweusMiUVOSMXzP7
         pD6xDFmsJds5CWUS1QDhAJt6O1p8p2LIMq26r8G3AZ4DdywCdxEXpOVNXv8SXf+aUun8
         5Oue2VRE41j1hTWs3prfHeyycQZ9jjkfq/Ndk=
References: <20100128135405.GA28931@basil.fritz.box>
Message-Id: <DE24773B-F00A-4866-8E88-AE63E6135743@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100128135405.GA28931@basil.fritz.box>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: PNP PS/2 probing racy?
Date: Thu, 28 Jan 2010 07:57:47 -0800
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Jan 28, 2010, at 5:54 AM, Andi Kleen <andi@firstfloor.org> wrote:

>
> Hi,
>
> I noticed that on one test system of machine when booting the same
> kernel I get:
>
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
>
> and sometimes on another boot
>
> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
>
> Since I presume the BIOS does not change, is it possible the Linux
> procedure for this PNP probe is racy? I haven't checked the code so  
> far.
>

Are you using KVM with that box by any chance?

-- 
Dmitry

