Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbZFCOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbZFCOXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZFCOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:23:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZFCOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:23:38 -0400
Date: Wed, 3 Jun 2009 10:23:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tracing/events: fix output format of user stack
In-Reply-To: <1244016090-7814-3-git-send-email-walimisdev@gmail.com>
Message-ID: <alpine.DEB.2.00.0906031023240.14994@gandalf.stny.rr.com>
References: <1244016090-7814-1-git-send-email-walimisdev@gmail.com> <1244016090-7814-2-git-send-email-walimisdev@gmail.com> <1244016090-7814-3-git-send-email-walimisdev@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, walimis wrote:

> According to "events/ftrace/user_stack/format", fix the output of
> user stack.
> 
> before fix:
> 
>   sh-1073  [000]    31.137561:  <b7f274fe> <-  <0804e33c> <-  <080835c1>
> 
> after fix:
> 
>   sh-1072  [000]    37.039329:
>  =>  <b7f8a4fe>
>  =>  <0804e33c>
>  =>  <080835c1>
> 
> Signed-off-by: walimis <walimisdev@gmail.com>

I'll queue this too, Thanks!

-- Steve
