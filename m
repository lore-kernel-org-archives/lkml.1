Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZA2GmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZA2GmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZA2GmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:42:11 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:13092 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751651AbZA2GmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:42:10 -0500
Date: Thu, 29 Jan 2009 15:39:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sh: Relax inline assembly constraints
Message-ID: <20090129063908.GE32243@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Matt Fleming <matt@console-pimps.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1232486078-11227-1-git-send-email-matt@console-pimps.org> <1232486078-11227-2-git-send-email-matt@console-pimps.org> <1232486078-11227-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232486078-11227-2-git-send-email-matt@console-pimps.org> <1232486078-11227-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:14:37PM +0000, Matt Fleming wrote:
> When dereferencing the memory address contained in a register and
> modifying the value at that memory address, the register should not be
> listed in the inline asm outputs. The value at the memory address is an
> output (which is taken care of with the "memory" clobber), not the register.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

On Tue, Jan 20, 2009 at 09:14:38PM +0000, Matt Fleming wrote:
> Now that atomic_t is a generic opaque type for all architectures, it is
> unwise to use intimate knowledge of its internals when manipulating it.
> 
> Instead of relying on the "counter" member being at offset 0 from the
> beginning of an atomic_t, explicitly reference the member. This guards
> us from any changes to the layout of the beginning of the atomic_t type.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

Applied, thanks.
