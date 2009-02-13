Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZBMUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZBMUs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZBMUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:48:19 -0500
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:36901 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZBMUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:48:19 -0500
X-Greylist: delayed 3762 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 15:48:19 EST
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090213134024.GA26549@srcf.ucam.org> <cone.1234551556.57236.4642.1000@onepiie> <20090213191815.GB1379@srcf.ucam.org>
Message-ID: <cone.1234554340.344388.4642.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acer Aspire One fan control
Date: Fri, 13 Feb 2009 20:45:40 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett writes:

>> I get the temperature by calling ec_read(0x58) and can read/write the state 
>> of the fan by ec_write to / ec_read from 0x55. Actually I don't know if 
>> those embedded controller registers are used by the firmware. How can I 
>> find it out?
> 
> Ok, yup, that should be safe. It might be nice to implement this as an 
> hwmon driver, potentially tying it into the thermal layer.

Thank you very much, I will have a deeper look into hwmon and the thermal 
layer.

--peter
