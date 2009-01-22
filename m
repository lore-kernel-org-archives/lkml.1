Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZAVU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZAVU2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZAVU2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:28:01 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53057 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZAVU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:28:00 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: boot regression from rc1 to rc2
Date: Thu, 22 Jan 2009 21:28:20 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901222128.20865.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.29-rc2 crashes hard during boot on my laptop.
I've bisected it down to commit c6cb0e878446c79f42e7833d7bb69ed6bfbb381f
ACPI: EC: Don't trust ECDT tables from ASUS

The laptop boots with "acpi=off".

	Regards
		Oliver
