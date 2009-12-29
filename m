Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbZL2Xtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbZL2Xtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 18:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZL2Xtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 18:49:41 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59195 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZL2Xtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 18:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=IUQavs3J7FCnRiViiBO9/i6+1xr6NWjSCLpTKgEJaDkGVnWu6cbv7XWsYqOiQ7FtFl
         TYCpP60IQT65SiwAp67Egn1LxWSHPzr0D3IMOUidYALm19SfH+lcmSMfSX3HAo+aaxNZ
         gwF4LL53wgRZj3/kYOFP5EmmxF2LwotJFdrf4=
Message-ID: <4B3A9589.6060201@googlemail.com>
Date: Wed, 30 Dec 2009 00:49:29 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]drivers/usb/core/sysfs.c:201 unused variable 'value'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'value' is unused in 'set_reset_quirk()'.

Greetings René Bolldorf

--- ./drivers/usb/core/sysfs.c	2009-12-29 23:57:30.579982912 +0100
+++ ./drivers/usb/core/sysfs.c	2009-12-29 23:58:19.114982484 +0100
@@ -198,7 +198,7 @@ set_reset_quirk(struct device *dev, stru
  		const char *buf, size_t count)
  {
  	struct usb_device	*udev = to_usb_device(dev);
-	int			config, value;
+	int			config;

  	if (sscanf(buf, "%d", &config) != 1 || config < 0 || config > 1)
  		return -EINVAL;
