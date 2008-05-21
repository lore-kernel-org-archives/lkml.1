Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbYEUNBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbYEUNBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYEUNBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:01:23 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:54561 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYEUNBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tXoWf/HartjvILcFMwNCcjQxMxpmPGcA+EMfwm5M21CI+wm4oSEMnmmyw0okHAsC+4Vh9/mYuUWHdr0qVTq2oNP1AnJaDy7hUFCiRsRYCJFQtucKwme1GWIULofnidhNmWrjb3S8FpRYC8XDrwRCO2GQf/fp59HnBItJEb/O0tk=
Message-ID: <b49af93b0805210601n38030150w643565b60edc85da@mail.gmail.com>
Date: Wed, 21 May 2008 18:31:21 +0530
From: "vijay anand" <vijayanand.sj@gmail.com>
To: linux-kernel@vger.kernel.org, dave@awk.cz
Subject: [BUG] cdc-acm driver module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is vijay and new to this group. Normally I use to go through the
Linux kernel source and try to understand how things work.

Last week I was going through the cdc-acm driver source(linux-2.6.25).
I think there is a bug with that driver and I am not sure about it. So
I decided to post you guys and get your views on that.

The interface is claimed in 'acm_probe' using 'usb_driver_claim_interface' and
it has been released in 'acm_disconnect' using 'usb_driver_release_interface'.
This works fine as long as the control reaches 'acm_disconnect'.

What happens when the control never reaches the 'acm_disconnect'. Like simply
loading the driver and unloading the driver when the device is still in use.
In this case I hope the 'usb_driver_release_interface' never gets called.
Is it a bug? Do we have to do a 'usb_driver_release_interface' in  'acm_exit'.

Please clarify.

Thanks,
VJ
