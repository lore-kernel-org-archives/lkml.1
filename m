Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZBVATt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZBVATt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZBVATk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:19:40 -0500
Received: from mx0.towertech.it ([213.215.222.73]:32928 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753692AbZBVATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:19:39 -0500
Date: Sun, 22 Feb 2009 01:19:36 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222011936.35b21d6b@i1501.lan.towertech.it>
In-Reply-To: <20090221204147.GA25408@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
	<20090221204147.GA25408@n2100.arm.linux.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 20:41:47 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Confirmation: reverting 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 and
> removing the reference to I2C_DRIVERID_PCF8583 results in the regression
> being fixed and normal behaviour being restored.
> 
> Patch below.

 this is a nack on my side. the whole i2c has been converted to the
 new style model. everyone is following and this is
 the wrong way to fix the issue.

 the device must be instantiated in the appropriate
 platform code. 

 for an example of what needs to be done, you can grep for
 i2c_board_info in arch/arm .

 if you need help, just tell me where's the acorn related
 platform setup code and I'll have a look.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

