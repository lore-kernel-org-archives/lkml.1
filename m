Return-Path: <linux-kernel-owner+w=401wt.eu-S1762405AbXFBRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405AbXFBRrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761432AbXFBRrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:47:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:54588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092AbXFBRrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:47:09 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Tear <tarrqt@yahoo.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
Date: Sat, 2 Jun 2007 13:46:56 -0400
User-Agent: KMail/1.9.5
Cc: mingo@redhat.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <477357.96605.qm@web63602.mail.re1.yahoo.com>
In-Reply-To: <477357.96605.qm@web63602.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706021346.57067.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __init disable_blacklisted_ioapic(struct dmi_system_id *d)
> +{
> +	printk(KERN_WARNING "%s detected... Disabling IO-APIC\n", d->ident);
> +	skip_ioapic_setup = 1;
> +	return(0);
> +}

Wouldn't this also disable the IOAPIC in the (working) ACPI+IOAPIC case?
