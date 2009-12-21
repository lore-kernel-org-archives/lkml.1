Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZLULSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZLULSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZLULSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:18:07 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40194 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZLULSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:18:03 -0500
Date: Mon, 21 Dec 2009 16:47:59 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kprobes: get rid of distinct type warning
Message-ID: <20091221111759.GA12670@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:15:49AM +0100, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Every time I see this:
> 
> kernel/kprobes.c: In function 'register_kretprobe':
> kernel/kprobes.c:1038: warning: comparison of distinct pointer types lacks a cast
> 
> I'm wondering if something changed in common code and we need to do
> something for s390. Apparently that's not the case.
> Let's get rid of this annoying warning.
> 
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Heiko. I'd tested this on x86 and powerpc and neither throws the
warning. No wonder I missed it.
