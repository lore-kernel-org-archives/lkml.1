Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYFRMpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYFRMpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYFRMpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:45:09 -0400
Received: from ozlabs.org ([203.10.76.45]:33590 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYFRMpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:45:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18521.846.628816.525787@cargo.ozlabs.ibm.com>
Date: Wed, 18 Jun 2008 22:45:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
       486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
In-Reply-To: <20080618114906.GA23788@infradead.org>
References: <20080618101402.GF15718@soziologie.ch>
	<20080618114906.GA23788@infradead.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:

> On Wed, Jun 18, 2008 at 12:14:02PM +0200, Gaudenz Steinlin wrote:
> > Hi
> > 
> > The kernel modules for Mac on Linux (MOL) need handle_mm_fault. 
> > MOL is a GPL licensed virtual machine to run MacOS(X) on PPC Linux.
> 
> Has been rejected a few times.  An now that we actually have kvm
> for powerpc in tree MOL should just merge with that project and
> do the right things in tree instead of beeing a really hacky
> module subverting the VM.

We don't have KVM for the "classic" 32-bit PowerPC processors, only
for the 44x family.  And doing KVM for the classic 32-bit processors
would probably involve just as much hackery as MOL. :)

Paul.
