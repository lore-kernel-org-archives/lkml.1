Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZGBIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZGBIFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZGBIFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:05:11 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:3609 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZGBIE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:04:57 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4A4C6A28.9010102@tudelft.nl>
Date: Thu, 02 Jul 2009 10:04:56 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090623 Mandriva/2.0.0.22-1mdv2010.0 (2010.0) Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: Chris Verges <chrisv@cyberswitching.com>,
       Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] adxl345 accelerometer hwmon driver
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>	<4A4BB4AB.7010003@cam.ac.uk>	<68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local> <20090701221310.1d6aa587@hyperion.delvare>
In-Reply-To: <20090701221310.1d6aa587@hyperion.delvare>
Content-Type: multipart/mixed;
 boundary="------------000307090007070702080400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000307090007070702080400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Op 01-07-09 22:13, Jean Delvare schreef:
> A few accelerometer drivers were originally added to drivers/hwmon
> because the chips also included some hwmon features (e.g. temperature
> sensor.) Now every new accelerometer driver gets dropped in
> drivers/hwmon "because there are other accelerometer drivers there".
> The LIS3LV02D driver is a perfect example of this... the device is not
> even registered as a hwmon driver! This driver definitely doesn't
> belong there.
> 
> Probably it's about time to put an end to this and kick all
> accelerometer drivers out of drivers/hwmon.
(I'm the maintainer of LIS3LV02D)
I completely agree with you, accelerometer drivers do not belong to
hwmon. Unfortunately, so far there has not been any landing place which
looked really more relevant. As soon as such a thing is available (maybe
an "accelerometer" subsystem) I'll be happy to move the driver :-)

Eric



--------------000307090007070702080400
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

begin:vcard
fn;quoted-printable:=C3=89ric Piel
n;quoted-printable:Piel;=C3=89ric
org:Technical University of Delft;Software Engineering Research Group
adr:HB 08.080;;Mekelweg 4;Delft;;2628 CD;The Netherlands
email;internet:E.A.B.Piel@tudelft.nl
tel;work:+31 15 278 6338
tel;cell:+31 6 2437 9135
x-mozilla-html:FALSE
url:http://pieleric.free.fr
version:2.1
end:vcard


--------------000307090007070702080400--
