Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYGJB5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYGJB5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYGJB5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:57:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbYGJB5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:57:44 -0400
Date: Wed, 9 Jul 2008 18:51:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 13/34] AMD IOMMU: add functions to parse IOMMU memory
 mapping requirements for devices
Message-Id: <20080709185144.9f144d5e.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-14-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:49 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> +static int __init init_memory_definitions(struct acpi_table_header *table)
> +{
> +	u8 *p = (u8 *)table, *end = (u8 *)table;
> +	struct ivmd_header *m;
> +
> +	INIT_LIST_HEAD(&amd_iommu_unity_map);

Define with LIST_HEAD().
