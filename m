Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZEQU7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZEQU7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZEQU6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:58:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:44009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZEQU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:58:33 -0400
Date: Sun, 17 May 2009 13:58:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] kernel:async function call:introduce async_run
Message-ID: <20090517135827.502fb4c3@infradead.org>
In-Reply-To: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
References: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 08:33:49 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> In fact, some async function call does not need to check, async_run
> is right for this kind of function call. Also, async_run is very
> suitable to used to start a thread in atomic context to do somthing,
> for now there is no such kind of kernel api, eg. kthread_run
> can not be started in atomic context.

I don't think it's worth complicating the cookie allocation;
I don't assume that what you're scheduling is going to take a really
long time...

if it does it's better to make a private domain for it.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
