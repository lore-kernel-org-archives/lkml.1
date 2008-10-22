Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYJVS6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYJVS6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbYJVS6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:58:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759499AbYJVS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:58:29 -0400
Date: Wed, 22 Oct 2008 11:57:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 03/11] ftrace: return error on failed modified text.
Message-Id: <20081022115727.ca832616.akpm@linux-foundation.org>
In-Reply-To: <20081022185135.952553961@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
	<20081022185135.952553961@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 14:43:16 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Return -1 on failed modified text.
> 

changelog fails to explain the reason for the change.

> +	if (__copy_to_user_inatomic((char __user *)ip, new_code,
> +				    MCOUNT_INSN_SIZE))
> +		return -1;

why not -EFAULT?


