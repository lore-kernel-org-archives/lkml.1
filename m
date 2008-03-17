Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbYCQSEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbYCQSEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYCQSEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:04:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:40935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYCQSEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:04:36 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
Date: Mon, 17 Mar 2008 13:48:13 -0400
User-Agent: KMail/1.9.9
Cc: Dave Hansen <haveblue@us.ibm.com>, Tilman Schmidt <tilman@imap.cc>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <1205530551.8167.20.camel@nimitz.home.sr71.net> <47DB013D.3060102@tremplin-utc.net>
In-Reply-To: <47DB013D.3060102@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171348.13417.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We used to have 
> a different way but it was even uglier: append the DSDT after the 
> initramfs, and then access it _directly_. This implies teaching 
> populate_rootfs() to not panic when seeing DSDTs and loosing the benefit 
> of the compression.

DSDT's are generally 4KB to 64KB, so I don't think compression
for a DSDT override is important.

-Len
