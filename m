Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZAFJ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZAFJ24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZAFJ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:28:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:3037 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZAFJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QDRnUcpZoW6LZAQy7v0XWAAU6aRTZlYBFdMwgrcwI9xqZ8VOjkMWyJNDnpx7ZR5AWj
         U7DBskmKjRMaKJmEElBbY0uSeBSD/lo53aujZOCDKDYRv5LI/HpxKGv+y64Ofrvx9ZNP
         Hn5ehu0qhaPwLxkQhrofMA4IG0M9kIAyPxmpA=
Date: Tue, 6 Jan 2009 11:29:00 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Ingo Molnar <mingo@elte.hu>
Cc: penberg@cs.helsinki.fi, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: Remove the relay version of kmemtrace.
Message-ID: <20090106092900.GA5297@localhost>
References: <20090105191330.GA1498@elte.hu> <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro> <20090106084905.GB29917@elte.hu> <20090106091927.GA29863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106091927.GA29863@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:19:27AM +0100, Ingo Molnar wrote:
> 
> I needed the small fixlet below as well.
> 
> 	Ingo
> 
> -------------->
> >From 3e80680208ba6ce9635ca7c21ad0019442ea166a Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 6 Jan 2009 10:16:35 +0100
> Subject: [PATCH] kmemtrace: add kmemtrace_init()
> 
> Impact: build fix
> 
> leftover from the relayfs version - but we want to keep it because
> this call is the earliest opportunity when we can start kmemtrace
> tracing. (after kmem_cache_init()).
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Good, I'll get acquainted with ftrace and see if we can make kmemtrace
start earlier.


	Cheers,
	Eduard

