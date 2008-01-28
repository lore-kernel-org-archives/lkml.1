Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYA1B0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYA1B0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYA1B0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:26:09 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:58843 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYA1B0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:26:08 -0500
Date: Mon, 28 Jan 2008 01:25:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-ID: <20080128012549.GA24166@srcf.ucam.org>
References: <20071226020325.GA21099@srcf.ucam.org> <200801241644.49114.lenb@kernel.org> <20080126220045.b93db7c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220045.b93db7c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 10:00:45PM -0800, Andrew Morton wrote:
> - Create a new /sys node with a new name which has the new semantics.

The semantics are the same as they always have been - values between 0 
and max_brightness are valid values. If you've made assumptions about 
what max_brightness is, then that's a bug in the userspace application 
rather than a change in the semantics of the interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
