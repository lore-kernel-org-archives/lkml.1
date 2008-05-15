Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYEOJCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYEOJCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYEOJB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:01:56 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:22251 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYEOJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:01:55 -0400
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: Andi Kleen <andi@firstfloor.org>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 15 May 2008 11:01:09 +0200
In-Reply-To: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Tue, 13 May 2008 15:04:50 +0900")
Message-ID: <87y76cym96.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 May 2008 08:54:09.0095 (UTC) FILETIME=[3CFACD70:01C8B669]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

> This patchset adds per-device dma_mapping_ops support for
> CONFIG_X86_64 like POWER architecture does. This change enables us to
> cleanly fix the Calgary IOMMU issue that some devices are not behind
> the IOMMU [1]. It also would be helpful to handle KVM PCI passthrough.

This makes it basically impossible to do stack ops, which some 
people have been doing.

-Andi
