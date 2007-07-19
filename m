Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbXGSNYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbXGSNYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXGSNYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:24:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbXGSNYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:24:03 -0400
Date: Thu, 19 Jul 2007 08:20:03 -0500
From: David Teigland <teigland@redhat.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix memory leak in dlm_add_member() when dlm_node_weight() returns less than zero
Message-ID: <20070719132003.GA782@redhat.com>
References: <200707190027.43195.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707190027.43195.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 12:27:43AM +0200, Jesper Juhl wrote:
> Greetings,
> 
> There's a memory leak in fs/dlm/member.c::dlm_add_member().
> 
> If "dlm_node_weight(ls->ls_name, nodeid)" returns < 0, then 
> we'll return without freeing the memory allocated to the (at 
> that point yet unused) 'memb'.
> This patch frees the allocated memory in that case and thus 
> avoids the leak.

Yep, thanks.

Dave

