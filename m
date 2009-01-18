Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbZAREYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbZAREYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763666AbZAREWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:22:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:37901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763660AbZAREWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:22:22 -0500
Message-ID: <4972AE71.2030506@kernel.org>
Date: Sun, 18 Jan 2009 13:22:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] x86-64: Use absolute displacements for per-cpu
 accesses.
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com> <1232115396-26367-6-git-send-email-brgerst@gmail.com> <1232115396-26367-7-git-send-email-brgerst@gmail.com> <1232115396-26367-8-git-send-email-brgerst@gmail.com> <1232115396-26367-9-git-send-email-brgerst@gmail.com> <1232115396-26367-10-git-send-email-brgerst@gmail.com> <1232115396-26367-11-git-send-email-brgerst@gmail.com> <1232115396-26367-12-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232115396-26367-12-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 04:22:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
> Accessing memory through %gs should not use rip-relative addressing.
> Adding a P prefix for the argument tells gcc to not add (%rip) to
> the memory references.

Nice catch.  I dind't know about the P prefix thing.  It also is used
in other places too.  Hmmm... I can't find anything about the P
argument prefix in the gcc info page (4.3).  Any ideas where I can
find some information about it?  It's a bit weird that it's not a
constraint prefix but an argument one.

Thanks.

-- 
tejun
