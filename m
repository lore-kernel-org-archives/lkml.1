Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYKLP5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYKLP5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYKLP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:57:28 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34093 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbYKLP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:57:27 -0500
Date: Wed, 12 Nov 2008 21:26:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH 4/7] kprobes: Support probing module __exit function
Message-ID: <20081112155629.GC5199@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F19A.9050904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919F19A.9050904@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:56:58PM -0500, Masami Hiramatsu wrote:
> Allows kprobes to probe __exit routine.
> This adds flags member to struct kprobe. When module is freed(kprobes hooks
> module_notifier to get this event), kprobes which probe the functions in
> that module are set to "Gone" flag to the flags member. These "Gone" probes
> are never be enabled.
> Users can check the GONE flag through debugfs.
> 
> This also removes mod_refcounted, because we couldn't free a module if
> kprobe incremented the refcount of that module.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
