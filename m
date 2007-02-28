Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXB1JNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXB1JNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXB1JNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:13:44 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:46768 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXB1JNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:13:42 -0500
Date: Wed, 28 Feb 2007 18:11:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: John Reiser <jreiser@BitWagon.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: fully honor vdso_enabled [i386, sh; x86_64?]
Message-ID: <20070228091110.GA26128@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	John Reiser <jreiser@BitWagon.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <45DDFD98.4080300@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DDFD98.4080300@BitWagon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 12:31:20PM -0800, John Reiser wrote:
> This patch changes arch_setup_additonal_pages() to honor vdso_enabled.
> For i386 it also allows the option of a fixed addresss to avoid
> fragmenting the address space.  Compiles and runs on i386.
> x86_64 [IA32 support] and sh maintainers also please comment.
> 
We didn't actually have the sysctl entry wired up on SH, but once that's
done, this patch works fine there too.

Andrew, do you want a separate patch for the vdso_enabled sysctl or
is it more convenient through my git tree?

Acked-by: Paul Mundt <lethal@linux-sh.org>
