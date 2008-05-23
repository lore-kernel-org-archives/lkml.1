Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbYEWGgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbYEWGgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYEWGgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:36:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35733 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYEWGgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:36:10 -0400
Message-ID: <4836660B.3080406@jp.fujitsu.com>
Date: Fri, 23 May 2008 15:36:59 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ACPI: add "OSI(Linux) checking procedure" for ia64 machines
References: <4816F9B9.3090609@jp.fujitsu.com>
In-Reply-To: <4816F9B9.3090609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Currently there is no "OSI(Linux) checking procedure" on ia64,
so it is no use adding ia64 machines' entry to the acpi_osi_dmi_table
for the purpose of enabling or disabling OSI(Linux).

The following first patch adds acpi_osi_dmi_table evaluation procedure
for ia64 machines. The second patch adds our ia64 machine's entry to
its table, because we want to enable OSI(Linux) on our mahines.

* [PATCH 1/2] ACPI: add acpi_osi_dmi_table evaluation procedure for ia64 
machines
* [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST

Best regards,
Taku Izumi <izumi.taku@jp.fujitsu.com>

