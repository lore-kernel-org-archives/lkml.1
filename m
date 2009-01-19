Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZASThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZASThW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZASThI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:37:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2745 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZASThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:37:07 -0500
Date: Mon, 19 Jan 2009 19:37:05 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: RFC: Working around dynamic device allocation in i2c.  Interaction with other subystems.
Message-ID: <20090119193704.GA16803@sirena.org.uk>
References: <4974D20F.20209@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974D20F.20209@cam.ac.uk>
X-Cookie: Onward through the fog.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 07:18:39PM +0000, Jonathan Cameron wrote:

> 1) Relax the constraints that the token used for device identification
>    in subsystems using the regulators approach to a void * and use
>    the platform data pointer of an i2c device.  Note this requires
>    every device which may need a regulator to have platform data.
>    Whilst this would work, it is far from ideal.

This would also remove the ability of the APIs using this to use the
struct device for other things like showing what they're doing in sysfs
or use dev_printk.
