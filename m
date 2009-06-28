Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZF1W2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZF1W2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZF1W2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:28:32 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:49726 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbZF1W2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:28:31 -0400
From: Frans Pop <elendil@planet.nl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH] acpi processor: simplify needlessly complex printk
Date: Mon, 29 Jun 2009 00:28:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
References: <200906282203.55643.elendil@planet.nl> <4A47E85D.3020202@gmail.com>
In-Reply-To: <4A47E85D.3020202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906290028.33285.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jun 2009 22:28:33.0951 (UTC) FILETIME=[C5A7DAF0:01C9F83F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Justin P. Mattock wrote:
> Would it be better to capitalize the S and add a period at the
> end, or does it not matter?

Kernel messages are in general not sentences.

I thought of removing the parenteses, but if you look at the context of 
the message then that only makes sense if other messages are modified at 
the same time. The messages below appear together for my system and their 
consistency could definitely be improved, but IMO that's better done in a 
separate patch.

ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:00: registered as cooling_device7
ACPI: Processor [CPU0] (supports 8 throttling states)
