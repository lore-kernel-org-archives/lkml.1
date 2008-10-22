Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYJVS6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYJVS6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYJVS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:57:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759955AbYJVS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:57:27 -0400
Date: Wed, 22 Oct 2008 11:56:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
Message-Id: <20081022115607.c0b3974c.akpm@linux-foundation.org>
In-Reply-To: <20081022185135.618026303@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
	<20081022185135.618026303@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 14:43:14 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> +if ($arch eq "x86") {
> +    if ($bits == 64) {
> +	$arch = "x86_64";
> +    } else {
> +	$arch = "xi386";

?

> +    }

(how well was this tested?)
