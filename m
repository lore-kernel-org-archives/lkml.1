Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYA1F2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYA1F2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYA1F21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:28:27 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:56561 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYA1F20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:28:26 -0500
Date: Mon, 28 Jan 2008 05:28:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-ID: <20080128052804.GA26091@srcf.ucam.org>
References: <20071226020325.GA21099@srcf.ucam.org> <200801241644.49114.lenb@kernel.org> <20080126220045.b93db7c9.akpm@linux-foundation.org> <20080128012549.GA24166@srcf.ucam.org> <20080127211013.1ddaa6a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127211013.1ddaa6a1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 09:10:13PM -0800, Andrew Morton wrote:

> You cannot seriously tell me that if we are to change this range from 0-8
> up to 0-100 then this is not a backwards-incompatible change in
> semantics.

We're talking about changing 0-100 to 0-something sane, because the 
current driver is quite clearly broken. And yes, I'm perfectly happy to 
say that - the reason that max_brightness is exported is to allow 
userspace to determine what range of values is acceptable, and if 
userspace ignores that then things are going to break for it at some 
point.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
