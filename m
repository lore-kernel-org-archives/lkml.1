Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYKLP5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYKLP5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYKLP5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:57:00 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47029 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYKLP47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:56:59 -0500
Date: Wed, 12 Nov 2008 21:25:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Srinivasa Ds <srinivasa@in.ibm.com>
Subject: Re: [PATCH 3/7] kprobes: Add __kprobes to kprobe internal functions
Message-ID: <20081112155558.GB5199@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F188.1060900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919F188.1060900@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:56:40PM -0500, Masami Hiramatsu wrote:
> Add __kprobes to kprobes internal functions for protecting
> from probing by kprobes itself.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  kernel/kprobes.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> This patch is required for the patch 5/7.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
