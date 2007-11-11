Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXKKSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXKKSH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXKKSHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:07:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbXKKSHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:07:14 -0500
Date: Sun, 11 Nov 2007 19:07:09 +0100
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
Message-ID: <20071111180709.GG22277@bingen.suse.de>
References: <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com> <1194633878886-git-send-email-gcosta@redhat.com> <11946338832681-git-send-email-gcosta@redhat.com> <1194633888761-git-send-email-gco!sta@redhat.com> <11946338932611-git-send-email-gcosta@redhat.com> <1194633898545-git-send-email-gcosta@redhat.com> <11946339033567-git-send-email-gcosta@redhat.com> <11946339082711-git-send-email-gcosta@redhat.com> <11946339142999-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11946339142999-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 04:43:05PM -0200, Glauber de Oliveira Costa wrote:
> This patch makes vsmp a paravirt client. It now uses the whole
> infrastructure provided by pvops. When we detect we're running
> a vsmp box, we change the irq-related paravirt operations (and so,
> it have to happen quite early), and the patching function

The PARAVIRT ifdefs look wrong. Surely you don't need them at all
because it cannot work at all without paravirt.

Also you got some white space damage.

And the "EM64T based comment" is wrong because there are AMD based 
vSMPs too.

-Andi
