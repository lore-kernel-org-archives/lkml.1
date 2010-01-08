Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393Ab0AHXvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0AHXvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238Ab0AHXvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:51:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab0AHXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:51:07 -0500
Date: Fri, 8 Jan 2010 15:50:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: paulmck@linux.vnet.ibm.com, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Add rcustring ADT for RCU protected strings v2
Message-Id: <20100108155044.c2fa93a3.akpm@linux-foundation.org>
In-Reply-To: <20100105021526.17EF2B17C2@basil.firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
	<20100105021526.17EF2B17C2@basil.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Jan 2010 03:15:26 +0100 (CET)
Andi Kleen <andi@firstfloor.org> wrote:

> +extern char *alloc_rcu_string(int size, gfp_t gfp);
> +extern void free_rcu_string(const char *string);
> +
> +/*
> + * size must be the same as alloc_rcu_string, don't
> + * use strlen on str!
> + */
> +extern char *access_rcu_string(char **str, int size, gfp_t gfp);

I think better names would be rcu_string_alloc(), rcu_string_free() and
rcu_string_access().

