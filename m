Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYCZOgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYCZOgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYCZOgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:36:32 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:36999 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYCZOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b1HwydFFoJlhkw/Xl36n/jRRvWKADrj2YX2jt2GIsisSaqHqpPuNIXELV0YGh9G2g7U45iWJB8hykX37dPaLaTFlQTfafhPJd335X9zeGV6dxoRBXlxpnIl9HGS2ACQvKCr7i1qXvJpZdurkbfYDjlm/col64CuITR4Or4fUMH4=
Message-ID: <8bd0f97a0803260736v58c11f8g8a5f740c62891174@mail.gmail.com>
Date: Wed, 26 Mar 2008 10:36:30 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystick driver
Cc: dmitry.torokhov@gmail.com, khali@linux-fr.org, linux-input@vger.kernel.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       "Bryan Wu" <bryan.wu@analog.com>
In-Reply-To: <1206579622-21915-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206579622-21915-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 9:00 PM, Bryan Wu <cooloney@kernel.org> wrote:
>  +config JOYSTICK_AD7142
>  +       tristate "Analog Devices AD7142 Joystick support"
>  +       depends on BLACKFIN && I2C
>  +       ---help---
>  +         Say Y here if you want to support an AD7142 joystick

since you're going to send another patch anyways ;), this kconfig text
could use a line telling you the module name if built as a module.
-mike
