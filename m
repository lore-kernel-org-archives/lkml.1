Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850Ab0AKWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0AKWLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724Ab0AKWLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:11:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab0AKWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:11:45 -0500
Date: Mon, 11 Jan 2010 14:11:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>
Subject: Re: [patch 0/6] cpumask_of_node() should handle -1 as a node
Message-Id: <20100111141136.0ee352b3.akpm@linux-foundation.org>
In-Reply-To: <20100106045509.245662398@samba.org>
References: <20100106045509.245662398@samba.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 15:55:09 +1100
Anton Blanchard <anton@samba.org> wrote:

> A number of places in the kernel use cpumask_of_node(-1), but most arch
> NUMA implementations are broken. The following patches fix this.
> 

So..  what's happening here?  Nobody has applied the patches anywhere,
you later said "the scheduler oopses in a number of places with
CPUMASK_OFFSTACK and sparse node ids" and mention of a -stable backport
was mentioned.

