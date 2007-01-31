Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbXAaIC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbXAaIC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXAaIC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:02:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:39916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXAaIC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:02:28 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20-rc6-mm3
Date: Wed, 31 Jan 2007 02:57:33 -0500
User-Agent: KMail/1.9.5
Cc: Olivier Galibert <galibert@pobox.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070130090645.GC11823@dspnet.fr.eu.org> <20070130012631.8bb86c76.akpm@osdl.org>
In-Reply-To: <20070130012631.8bb86c76.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701310257.33888.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 04:26, Andrew Morton wrote:

> Len, what was in that merge anyway?  Lots of renaming and shuffling things
> around - the sorts of things which are safe as long as they compile OK.  But
> was there much substantive material in there as well?

The big thing was the new table manager.
Linux used to have multiple copies of the ACPI tables -- sometimes inconsistent.
Now, we use a single copy of each table.
Indeed, with the exception of the FADT -- where we need to convert multiple
versions into a single version, we map the tables directly where the BIOS
gives them to us and thus don't allocate any memory for them at all.

cheers,
-Len
