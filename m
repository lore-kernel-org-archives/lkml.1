Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXBEO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXBEO2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXBEO2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:28:21 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:35417 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbXBEO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:28:18 -0500
Date: Mon, 05 Feb 2007 08:27:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: USB PCI Host Controller Driver
In-reply-to: <1170658511.456856.28000@a75g2000cwd.googlegroups.com>
To: recklinux@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45C73ED3.3060804@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1170658511.456856.28000@a75g2000cwd.googlegroups.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

recklinux@gmail.com wrote:
 > Hi All,
 >
 > I am new to this Linux USB world i have no idea about the layring of
 > the USB at the Controller level, I ve worked on other USB controllers
 > on different platform so as i know that Linux worked in a totally
 > independent layered structure and need a very little change at every
 > layer ..
 > So what & where are the changes required for the controller ISP1562 in
 > Linux 2.6 ?
 >
 > Do i have to write the whole ehci & OHCI controller again ?
 > If there are any API's called by the upper layer that i should take
 > care of ?
 > Do i have to write a PCI Driver for probing and controller and then
 > write the specific registers ?
 > Is there any thing i should have to program where we schedule between
 > EHCI & OHCI or it is taken care by the controller ?
 >
 > Tks
 >

There should be no need for a new driver for this controller, the 
existing EHCI and OHCI drivers should work.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

