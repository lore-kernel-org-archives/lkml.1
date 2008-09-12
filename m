Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYILNmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYILNmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYILNmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:42:25 -0400
Received: from web57102.mail.re3.yahoo.com ([216.252.111.115]:28454 "HELO
	web57102.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273AbYILNmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:42:25 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2008 09:42:24 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=vav8X8dIAsvYF9TmrZnqCadT8V1ECx0QWYLpry+cxtuVRdYmpTFnLoJ54vmD2HUCLL1QXUQvb2WJ9NLWtg4JCaWZBDu7aWvkPwah7W45QDK7FVUFqAe253R5diSbmyHpJqCnaRYObJrG3IC3Dtc6brxekFlO5CZR1tjyi7BZSbw=;
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Fri, 12 Sep 2008 06:35:43 -0700 (PDT)
From: vidhumouli hunsigida <hv_mouli@yahoo.com>
Subject: Supporting new features in I2C
To: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <863377.52660.qm@web57102.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C host controller chip has two features named
HOLD and Slave Monitor.

HOLD is the typical feature of holding the clock low to support for the slow devices.
It can be enabled or disabled through software control by writing a bit in the registor.

I am writing a bus driver for this core.
I am not sure where and how this provision is to be added in the I2C adapter code.

I could not find any such provision in the exising bus drivers.
I could not find any related information in the Linux kernel documentation.

Can any one give me how can this be done?

Similarly for Slave Monitor, where a host monitors for the ack received from the slave device.
This can also be enabled/disabled by setting a bit in the register. How is this to be handled in the current i2c adapter code?

Thanks.


      
