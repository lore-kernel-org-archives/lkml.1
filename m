Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZIKJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZIKJz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZIKJz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:55:27 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41943 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZIKJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:55:26 -0400
Subject: Re: [bluetooth device not working fine]issue with usb core probe
 at hibernate & resume
From: Marcel Holtmann <marcel@holtmann.org>
To: Madula Sasikiran <Madula.Sasikiran@Atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C48506872FB7A@CHEXMB-01.global.atheros.com>
References: <44EE5C37ADC36343B0625A05DD408C48506872FB7A@CHEXMB-01.global.atheros.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 11:55:26 +0200
Message-Id: <1252662926.8931.65.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I am a bluetooth developer, came into bluetooth field recently. My bluetooth device is not working fine when I do hibernate and resume in linux 2.6.28 (ubuntu 9.0.4). It is working fine in the older versions. When I debugged the issue I see that when usb core is calling probe for the usb bluetooth dongle and the driver related to that is loading the firmware into the device. When I suspend and resume, usb core is calling probe and the firmware is getting loaded fine. For hibernate resume usb core is not calling probe and firmware is not getting loaded. I would like to know whether it is the issue with the usb core or Do I need to do any changes in the driver for this. Can I call the probe of my usb bluetooth dongle explicitly using any scripts?

according to MAINTAINERS, the actual correct mailing list for this is
linux-bluetooth@vger.kernel.org and not LKML.

Also the latest kernel is 2.6.31 and that is what you should report
issues against.

Regards

Marcel


