Return-Path: <linux-kernel-owner+w=401wt.eu-S1763359AbYEOS3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763359AbYEOS3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYEOS2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:28:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50259 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbYEOS2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:28:53 -0400
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com
In-Reply-To: <20080515181619R.tomof@acm.org>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <87y76cym96.fsf@basil.nowhere.org>  <20080515181619R.tomof@acm.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 11:25:11 -0700
Message-Id: <1210875911.5596.22.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 18:16 +0900, FUJITA Tomonori wrote:
> On Thu, 15 May 2008 11:01:09 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> > 
> > > This patchset adds per-device dma_mapping_ops support for
> > > CONFIG_X86_64 like POWER architecture does. This change enables us to
> > > cleanly fix the Calgary IOMMU issue that some devices are not behind
> > > the IOMMU [1]. It also would be helpful to handle KVM PCI passthrough.
> > 
> > This makes it basically impossible to do stack ops, which some 
> > people have been doing.
> 
> Seems that I misunderstand what those people want.
> 
> What those people want to do and how the stack ops achieve it? Or can
> you tell me where their patches are?
Yes an explanation of stack ops, or a pointer to a patch set that
implements them would be very useful.


