Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbXL0QrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbXL0QrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 11:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXL0QrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 11:47:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:41297 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbXL0QrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 11:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e6yvrzuToR+bb1FCBz5mWMj0PyPRvhXv+KJA1JxvDg3kL8wU9wB3+pxVOJFuOzx9Qpl5ureizD3BkSilGR8y6xNcq7we6FEXaoTHwx18rOM8h6R1cy63VDAYbDBX8hXb9sqFM1i4bu0OymUllWxXlkWfEoggHjktp+hZQAo2u3Q=
Message-ID: <9e4733910712270847j35778e43i66fda3eca9dc125@mail.gmail.com>
Date: Thu, 27 Dec 2007 11:47:10 -0500
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

On 12/19/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.


Are there any further objections to this patch? Can it all go in
through the powerpc trees or do the i2c people want to send it on?

-- 
Jon Smirl
jonsmirl@gmail.com
