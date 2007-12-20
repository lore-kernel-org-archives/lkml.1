Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbXLTX7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbXLTX7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXLTX71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:59:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:35465 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbXLTX70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:59:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S+CLFedFNMmOZvx2EA7+pRIAkAYU1sCgk3oiPfL9bhHwpanor/mXinW+uMj6gaQUWMjEatjJ1B1ARnwY78gd1yS5unuLfY3dz0E0mCk6eyUiOrZQRqK3jc8CGM0KSfzGW2SVqpTUeO2v2FKNRF+e3QXqd5Nakx5d18Hb6GBnwU8=
Message-ID: <9e4733910712201559k459ab574m74f7a84a637c8f0c@mail.gmail.com>
Date: Thu, 20 Dec 2007 18:59:25 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Version 17, series to add device tree naming to i2c
In-Reply-To: <20071220044136.20091.70984.stgit@terra.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220044136.20091.70984.stgit@terra.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there any other objections to this patch? If not, can it be
targeted for 2.6.25?

On 12/19/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> Since copying i2c-mpc.c to maintain support for the ppc architecture seems to be an issue; instead rework i2c-mpc.c to use CONFIG_PPC_MERGE #ifdefs to support both the ppc and powerpc architecture. When ppc is deleted in six months these #ifdefs will need to be removed.
>
> Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.
>
> The follow on patch to module-init-tools is also needed since the i2c subsystem has never implemented dynamic loading.
>
> The following series implements standard linux module aliasing for i2c modules on arch=powerpc. It then converts the mpc i2c driver from being a platform driver to an open firmware one. I2C device names are picked up from the device tree. Module aliasing is used to translate from device tree names into to linux kernel names. Several i2c drivers are updated to use the new aliasing.
>
> --
> Jon Smirl
> jonsmirl@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com
