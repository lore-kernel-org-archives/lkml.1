Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXHQTq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXHQTq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXHQTqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:46:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759781AbXHQTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:46:40 -0400
Date: Fri, 17 Aug 2007 12:45:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via
 proc/<pid>
Message-Id: <20070817124547.5415a839.akpm@linux-foundation.org>
In-Reply-To: <20070817105918.GA13937@hmsreliant.think-freely.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org>
	<20070816123538.GA10430@hmsreliant.think-freely.org>
	<4379.1187338166@turing-police.cc.vt.edu>
	<20070817105918.GA13937@hmsreliant.think-freely.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 06:59:18 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> Currently, there exists no method for a process to query the resource
> limits of another process.  They can be inferred via some mechanisms but they
> cannot be explicitly determined.  Given that this information can be usefull to
> know during the debugging of an application, I've written this patch which
> exports all of a processes limits via /proc/<pid>/limits.

I'm struggling with this a bit.  Sure, it _might_ be handy on some
occasions to be able to get at this information.  But I've never seen
anyone ask for it before, and it _is_ determinable by other means, if only
strace.

How do we justify adding yet more stuff to the kernel?
