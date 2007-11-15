Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXKOXg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXKOXg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXKOXgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:36:18 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1263 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbXKOXgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:36:17 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: 2.6.24-rc2-mm1: undefined reference to `local_apic_timer_c2_ok'
Date: Fri, 16 Nov 2007 00:35:58 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <200711152325.36541.m.kozlowski@tuxland.pl> <200711151749.03950.lenb@kernel.org>
In-Reply-To: <200711151749.03950.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711160036.00595.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > local_apic_timer_c2_ok
> 
> hmm, looks like you're missing CONFIG_X86_LOCAL_APIC
> so does this go away when you add CONFIG_SMP
> or CONFIG_X86_UP_APIC?

Yes it does. In both cases.

Regards,

	Mariusz
