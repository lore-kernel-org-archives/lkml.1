Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZFWSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZFWSci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZFWScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:32:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36199 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZFWScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:32:03 -0400
Date: Tue, 23 Jun 2009 19:31:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090623183153.GB12814@srcf.ucam.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245741246-6503-1-git-send-email-lenb@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a huge amount of overlap between SFI and ACPI. 
Couldn't this have simply taken the form of some additional ACPI tables 
and a decoupling of ACPI enumeration from runtime AML interpretation? 
How final is this spec?

I realise that we're pretty much constrained to implementing this if 
hardware actually ships with it, but it seems to be an additional 
firmware interface with no real benefit - as far as I can tell it's not 
possible for a platform to meaningfully implement both ACPI and SFI 
without duplicating information?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
