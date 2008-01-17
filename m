Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYAQXbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYAQXbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYAQXb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:31:28 -0500
Received: from mail.nutech.com ([204.10.18.136]:3220 "EHLO mail.nutech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYAQXb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:31:27 -0500
Date: Thu, 17 Jan 2008 15:31:26 -0800
Message-Id: <200801171531.AA26017902@mail.nutech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: "mathewss" <mathewss@mail.nutech.com>
Reply-To: <mathewss@mail.nutech.com>
To: <linux-kernel@vger.kernel.org>
Subject: mos7720. anyone actualy have it wokring?
X-Mailer: <IMail v8.22>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a
  http://www.tigerdirect.com/applications/SearchTools/item-details.asp?EdpNo=2893289&CatId=464

uses mos7720 chip.

they have a linux driver on the site but it wont work on newer 2.6 kernels it uses SLAB_ATOMIC etc. needs updating.

 The 2.6 kernel has this driver and i have seen some activity 6 months ago on it but nothing recent. 

This driver for me does not work when i try to cat /dev/ttyUSB2
it fails and when i try to run

statserial /dev/ttyUSB2 
statserial: TIOCMGET failed: Invalid argument


 debugging seems to get me a bit lost one thing i notice is that the interrupt handeler never gets turned off. Other serial usb modules do remove the interrupt on close. 

Was hoping someone had this hardware and had tested to see if it is just me.

 Regards
  Sean Mathews

struct SoftwareProfessional {
   double salary;
   long   lunches;
   float  jobs;
   char   unstable;
   void   work;
   short  tempers;
}; 




________________________________________________________________
Sent via the WebMail system at mail.nutech.com


 
                   
