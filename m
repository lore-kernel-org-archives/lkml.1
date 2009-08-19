Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZHSJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZHSJit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZHSJir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:38:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48983 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751439AbZHSJio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:38:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
References: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain> <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, Kumar Gala <galak@kernel.crashing.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: spin_is_locked() broken for uniprocessor?
Date: Wed, 19 Aug 2009 10:38:06 +0100
Message-ID: <7099.1250674686@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> > which implies to me that spin_is_locked() will always return false.  Is this
> > expected behavior.
> 
> That's wrong. spin_is_locked should always return true on UP.

Surely it's not that simple?  Maybe spin_is_lock() should be undefined on UP.

David
