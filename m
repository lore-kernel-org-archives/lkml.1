Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYAOJaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYAOJaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYAOJ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:29:53 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:43299 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYAOJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:29:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TR7qlm+rS1l5iJ77eaQIK/it/kKfu4zJAU+RRiP1UozFAtSAMl5WowAEBx+epSzPDmHtjPqsvZg1rNMWy2AQ+qcIMx1T0QKpuQ9CtCz8ftnbqMgvQJGh6KWbEM2r6pMMPLW8RwUPXMJQUo49vx7JZCrEsm3i19ZJKY4rmmA27i4=
Subject: Re: [PATCH] [13/31] CPA: Use macros to modify the PG_arch_1 page
	flags in change_page_attr
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <20080114221645.90C5D14F83@wotan.suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221645.90C5D14F83@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 01:29:51 -0800
Message-Id: <1200389391.16794.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 23:16 +0100, Andi Kleen wrote:
> Instead of open coding the bit accesses uses standard style
> *PageDeferred* macros. 
> 

Any reason these couldn't be static inlines in a shared header?

asm/page.h perhaps?

Cheers,

Harvey


