Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZK1AUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZK1AUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 19:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZK1AUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 19:20:34 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:62668 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZK1AUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 19:20:32 -0500
Date: Fri, 27 Nov 2009 19:20:16 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
To: linux-kernel@vger.kernel.org
Message-id: <4B106CC0.4050406@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre)
 Gecko/20091109 Fedora/3.0-3.10.b4.fc12 Thunderbird/3.0b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having given up for now on VT-D, I rebooted 2.6.38 rc8 with 
intel_iommu=off. Whilst my myriad of broken bios issues cleared, I now 
see in perf top acpi_os_read_port as continually the busiest function. 
With intel_iommu enabled, _spin_lock was always on top, and nothing else 
was notable.

This seems odd to me, perhaps this will make sense to someone else.

FWIW, I'm running on an Asus p6t deluxe v2; ht enabled; no errors or 
oddities in dmesg or /var/log/messages.
