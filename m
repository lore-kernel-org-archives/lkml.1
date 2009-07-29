Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZG2GOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZG2GOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZG2GOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:14:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38069 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZG2GOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:14:06 -0400
Date: Wed, 29 Jul 2009 09:54:23 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [BUGFIX PATCH] kprobes: Use kernel_text_address() for checking
	probe address
Message-ID: <20090729042423.GA5232@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090728234723.15708.54455.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728234723.15708.54455.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 07:47:23PM -0400, Masami Hiramatsu wrote:
> Use kernel_text_address() for checking probe address instead of
> __kernel_text_address(), because __kernel_text_address() returns
> !0 for init functions even after relaseing those functions.
> That will hit a BUG() in text_poke().
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
