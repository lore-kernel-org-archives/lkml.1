Return-Path: <linux-kernel-owner+w=401wt.eu-S939376AbXG3Qvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939376AbXG3Qvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936097AbXG3Qvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:51:39 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:38598
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935595AbXG3Qvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:51:38 -0400
Date: Mon, 30 Jul 2007 09:50:50 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel@vger.kernel.org
Subject: why does selecting ACPI now require PNP?
Message-ID: <Pine.LNX.4.64.0707300948020.11330@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in the current thread 'long term regression' we're troubleshooting 
printing problems that seem to be triggered by ACPI_PNP. in sometime 
between 2.6.18 and 2.6.22 configuring ACPI started forcing ACPI_PNP even 
if PNP was otherwise disabled.

given the recent discussion on ACPI forcing HOTPLUG_CPU I thought it 
appropriate to ask the question of why configuring ACPI should then enable 
PNP?

David Lang
