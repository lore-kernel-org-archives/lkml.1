Return-Path: <linux-kernel-owner+w=401wt.eu-S1765044AbXEYShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765044AbXEYShz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763517AbXEYSht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:37:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:23769 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763078AbXEYShs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NfJYzwBuRuTiaEACPZAKZkAZ/AyL3KsQTkRFYtUtBwLp9cUS0q7dzSXXZeZAzHuuuIqT0FFr+NCuuoI1tKExFJzCL65u6OEIs8mikLjx3FjG1OWB5Ha2acpR8g9OY/d2MbJ8tvDStF737isacTnBp9IvezKE9qsM8dOLarIo74E=
Message-ID: <114492e40705251137k53d9c341q3430710c75408b33@mail.gmail.com>
Date: Fri, 25 May 2007 15:37:46 -0300
From: "Rodrigo Pereira" <rodripe@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: sysfs permitions on class leds
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry my English)

I'm helping Márton Németh  in a experimental mail led driver
leds-clevo-mail.c for clevo laptops and I have problems with this
driver:
this files
/sys/class/<ledname>trigger,  /sys/class/<ledname>/dalay_on and
/sys/class/<ledname>/delay_off  are  created  as 644 permissions. Also
ROOT controls the led. I think write udev rules but my rules don't
change this permissions.

The clevo mail led is a trigger led (time-trigger) for blinks the led
when a new mail arrives.

How can I change the permissions of the sysfs objects in runtime or userspace?

the code of this driver is found at
http://sourceforge.net/projects/clevo-mailled/

Thank you.

Rodrigo Pereira
