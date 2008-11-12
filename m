Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYKLQAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYKLQAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYKLP76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:59:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35618 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYKLP75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:59:57 -0500
Date: Wed, 12 Nov 2008 21:29:00 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 7/7] kprobes: Support probing module __init function
Message-ID: <20081112155900.GE5199@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F1C6.4030106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919F1C6.4030106@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:57:42PM -0500, Masami Hiramatsu wrote:
> Allow kprobes to probe module __init routines.
> When __init functions are freed, kprobes which probe those functions
> are set to "Gone" flag. These "Gone" probes are disarmed from the code
> and never be enabled.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
