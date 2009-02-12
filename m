Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZBLUof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZBLUof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbZBLUo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:44:27 -0500
Received: from smtprelay05.ispgateway.de ([80.67.18.43]:35639 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbZBLUo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:44:26 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Feb 2009 15:44:26 EST
Message-ID: <cone.1234471033.988571.5384.1000@mentalhome>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Acer Aspire One fan control
Date: Thu, 12 Feb 2009 21:37:13 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I own such an Acer Aspire One netbook and the noisy fan annoyed me. (The 
default hardware controlled fan is on all the time). So I wrote a small 
kernel module which monitors the temperature of the cpu and turns the fan on 
and off. After testing it a while on my and some of my friends netbooks, it 
seems to be stable and I thought about submitting this functionality to 
the mainline kernel. As this is my first time, I've got some questions and 
would really appreciate any help.

Do you think it makes sense to add it as seperate kernelmodule or should I 
patch another module, e.g. the drivers/misc/acer-wmi.c module?
Should I try also to add the functionality of the 
/proc/acpi/thermal_zone/THRM/* things in my first patch? Or just submit the 
general functionality for controlling the fan and add additional things step 
by step?

kind regards, and many thanks for your answers.
--peter
