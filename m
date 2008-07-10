Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYGJEpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYGJEpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 00:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYGJEpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 00:45:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbYGJEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 00:45:11 -0400
Date: Wed, 9 Jul 2008 21:39:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters for
 AMD IOMMU
Message-Id: <20080709213907.1e8b253b.akpm@linux-foundation.org>
In-Reply-To: <20080710132447T.fujita.tomonori@lab.ntt.co.jp>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
	<20080709185634.08c60937.akpm@linux-foundation.org>
	<20080710132447T.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 13:25:23 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> I have one related question, we should document all the kernel boot
> parameters in Documentation/kernel-parameters.txt?
> 
> Some of x86_64 boot parameters are in
> Documentations/x86/x86_64/boot-options.txt. The parameters of IOMMUs
> are scattered. It's confusing.

A single monolithic file has advantages.  I think I'd prefer that
personally.  I'd forgotten that the x86-specific one exists, actually.

If we _do_ want to split this all out into separate files, they should all
be in a dedicated subdirectory under ./Documentation/, no?
