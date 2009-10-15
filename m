Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbZJOXOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbZJOXOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZJOXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:14:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbZJOXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:14:22 -0400
Message-ID: <4AD7AC56.5040806@zytor.com>
Date: Thu, 15 Oct 2009 16:12:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Bryan Donlan <bdonlan@gmail.com>, bruce.w.allan@intel.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan> <1255645796-29944-1-git-send-email-bdonlan@gmail.com> <alpine.DEB.2.00.0910151831020.15317@p34.internal.lan> <alpine.DEB.2.00.0910151852510.8329@p34.internal.lan> <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMI system name seems to actually be blank:

Handle 0x0006, DMI type 1, 27 bytes
System Information
	Manufacturer:
	Product Name:
	Version:
	Serial Number:

As such, I suspect you need DMI_BOARD_VENDOR and DMI_BOARD_NAME:

Handle 0x0007, DMI type 2, 20 bytes
Base Board Information
	Manufacturer: Intel Corporation
	Product Name: DP55KG

You can double-check by looking at what names Linux uses in
/sys/class/dmi/id.

	-hpa
