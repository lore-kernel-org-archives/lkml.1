Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbXKOWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbXKOWte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbXKOWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:49:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:57611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbXKOWtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:49:23 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.24-rc2-mm1: undefined reference to `local_apic_timer_c2_ok'
Date: Thu, 15 Nov 2007 17:49:03 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <200711152325.36541.m.kozlowski@tuxland.pl>
In-Reply-To: <200711152325.36541.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151749.03950.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 17:25, Mariusz Kozlowski wrote:
> local_apic_timer_c2_ok

hmm, looks like you're missing CONFIG_X86_LOCAL_APIC
so does this go away when you add CONFIG_SMP
or CONFIG_X86_UP_APIC?
