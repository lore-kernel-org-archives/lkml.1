Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYEOJx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYEOJx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYEOJxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:53:17 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52768 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYEOJxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:53:12 -0400
Date: Thu, 15 May 2008 18:16:19 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <87y76cym96.fsf@basil.nowhere.org>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<87y76cym96.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080515181619R.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 11:01:09 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> > This patchset adds per-device dma_mapping_ops support for
> > CONFIG_X86_64 like POWER architecture does. This change enables us to
> > cleanly fix the Calgary IOMMU issue that some devices are not behind
> > the IOMMU [1]. It also would be helpful to handle KVM PCI passthrough.
> 
> This makes it basically impossible to do stack ops, which some 
> people have been doing.

Seems that I misunderstand what those people want.

What those people want to do and how the stack ops achieve it? Or can
you tell me where their patches are?
