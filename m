Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZIKOzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZIKOzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZIKOzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:55:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZIKOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:55:00 -0400
Subject: Re: [PATCH 0/3] kernel.h: move logging functions to separate file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <cover.1252639195.git.joe@perches.com>
References: <cover.1252639195.git.joe@perches.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 10:55:02 -0400
Message-Id: <1252680902.18996.687.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 20:29 -0700, Joe Perches wrote:
> kernel.h has gotten cluttered.
> Unclutter it and make it kernel style compatible.
> 
> Joe Perches (3):
>   include/linux/logging.h: Separate logging functions out of kernel.h
>   include/linux/logging.h: Reduce data usage of printk_once
>   include/linux/kernel.h: neaten and group functions and definitions
> 
>  include/linux/kernel.h  |  754 ++++++++++++++++-------------------------------
>  include/linux/logging.h |  313 ++++++++++++++++++++
>  2 files changed, 573 insertions(+), 494 deletions(-)
>  create mode 100644 include/linux/logging.h
> 

This is just clean up code, so I'm fine with it.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


