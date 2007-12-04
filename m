Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbXLDVbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbXLDVbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXLDVbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:31:04 -0500
Received: from mail.suse.de ([195.135.220.2]:49281 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXLDVbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:31:02 -0500
Date: Tue, 4 Dec 2007 14:56:50 +0100
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 3/10] allow sched clock to be overridden by paravirt
Message-ID: <20071204135650.GG11764@bingen.suse.de>
References: <11967666042130-git-send-email-gcosta@redhat.com> <11967666111489-git-send-email-gcosta@redhat.com> <11967666161585-git-send-email-gcosta@redhat.com> <11967666212496-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11967666212496-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 09:09:57AM -0200, Glauber de Oliveira Costa wrote:
> This patch turns the sched_clock into native_sched_clock.
> sched clock becomes a weak symbol, which can then give its
> place to a paravirt definition.

I ended up regretting that solution on i386, it would be better
to solve that more clearly with ifdefs.

-Andi
