Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYFRLtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYFRLtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYFRLtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:49:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYFRLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:49:07 -0400
Date: Wed, 18 Jun 2008 07:49:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: linux-kernel@vger.kernel.org, 486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080618114906.GA23788@infradead.org>
References: <20080618101402.GF15718@soziologie.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618101402.GF15718@soziologie.ch>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:14:02PM +0200, Gaudenz Steinlin wrote:
> Hi
> 
> The kernel modules for Mac on Linux (MOL) need handle_mm_fault. 
> MOL is a GPL licensed virtual machine to run MacOS(X) on PPC Linux.

Has been rejected a few times.  An now that we actually have kvm
for powerpc in tree MOL should just merge with that project and
do the right things in tree instead of beeing a really hacky
module subverting the VM.

