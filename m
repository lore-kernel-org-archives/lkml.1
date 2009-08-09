Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZHITQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZHITQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZHITQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:16:10 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:58047 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZHITQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:16:10 -0400
Date: Sun, 9 Aug 2009 11:34:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Simplify calls to cpuid by using + for in/out
 constraints
Message-ID: <20090809183443.GA24130@feather>
References: <20090808202113.GA21962@feather>
 <4A7F0511.6060408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7F0511.6060408@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 10:19:13AM -0700, H. Peter Anvin wrote:
> I would prefer to not apply this patch unless there is a good reason.
> The existing code isn't broken, and any time we change an asm()
> statement we risk triggering bugs in some obscure gcc version.

Fair enough.

> It isn't, of course, that the proposed change is wrong, but simply that
> it is an unnecessary change, and since it involves asm() statements I
> would like to reject it for churn reduction reasons.  Especially so
> since it is "build-tested only".

Given the risk of "bugs in some obscure gcc version", it doesn't seem
like running it or even comparing for identical code would validate
anything more than the correctness of the gcc version currently in use.

- Josh triplett
