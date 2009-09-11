Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZIKJkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZIKJkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZIKJkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:40:15 -0400
Received: from mail.atheros.com ([12.36.123.2]:19074 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZIKJkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:40:14 -0400
From: Madula Sasikiran <Madula.Sasikiran@Atheros.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 11 Sep 2009 15:10:11 +0530
Subject: [bluetooth device not working fine]issue with usb core probe at
 hibernate & resume
Thread-Topic: [bluetooth device not working fine]issue with usb core probe
 at hibernate & resume
Thread-Index: AQHKMsPahMxNOFDGqEyxn2rWhOW8fQ==
Message-ID: <44EE5C37ADC36343B0625A05DD408C48506872FB7A@CHEXMB-01.global.atheros.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am a bluetooth developer, came into bluetooth field recently. My bluetooth device is not working fine when I do hibernate and resume in linux 2.6.28 (ubuntu 9.0.4). It is working fine in the older versions. When I debugged the issue I see that when usb core is calling probe for the usb bluetooth dongle and the driver related to that is loading the firmware into the device. When I suspend and resume, usb core is calling probe and the firmware is getting loaded fine. For hibernate resume usb core is not calling probe and firmware is not getting loaded. I would like to know whether it is the issue with the usb core or Do I need to do any changes in the driver for this. Can I call the probe of my usb bluetooth dongle explicitly using any scripts?

Thanks and Regards,
Sasikiran.
