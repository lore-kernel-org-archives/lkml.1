Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXFSSza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXFSSza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762999AbXFSSzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:55:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761354AbXFSSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:55:22 -0400
Date: Tue, 19 Jun 2007 11:54:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Add stack usage monitoring
Message-Id: <20070619115422.de61abd5.akpm@linux-foundation.org>
In-Reply-To: <20070619184245.GA10567@c2.user-mode-linux.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:42:45 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> Add a machanism to see how much of a kernel stack is used.  This
> allocates zeroed stacks and sees where the lowest non-zero byte is on
> process exit.  It keeps track of the lowest value and logs values as
> they get lower.
> 

remind us again why the generic code is unsuitable?

> +	for(p = stack; p < end; p++){
> +		if(*p != 0)
> +	if(left < lowest_to_date){

Are there any plans to fix UML coding style?
