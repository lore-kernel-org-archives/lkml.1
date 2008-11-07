Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYKGVEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYKGVEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYKGVEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:04:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYKGVEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:04:42 -0500
Date: Fri, 7 Nov 2008 13:04:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Kemp <steve.30-11-2008.date@steve.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Many headers included multiple times
Message-Id: <20081107130435.884be9f5.akpm@linux-foundation.org>
In-Reply-To: <20081101111538.GA16874@steve.org.uk>
References: <20081101111538.GA16874@steve.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 11:15:38 +0000
Steve Kemp <steve.30-11-2008.date@steve.org.uk> wrote:

>  There are many source files which include the same header multiple
>  times.  Minimal initial patch included here, will submit the rest
>  shortly if there is interest.
> 
>   Quick tool to detect these: http://www.steve.org.uk/Software/kernel/

I flee in terror from patches like this because of the risk that
someone else will delete the _other_ #include, and this patch still
applies OK, so we end up removing both #includes and things break. 
This has happened before.

Thought: if the patch were to delete one #include and to then move the
other one to a different position in the #include order then this
couldn't happen.

