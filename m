Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbZHSJlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbZHSJlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZHSJlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:41:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZHSJlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:41:22 -0400
Subject: Re: spin_is_locked() broken for uniprocessor?
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <7099.1250674686@redhat.com>
References: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
	 <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
	 <7099.1250674686@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Aug 2009 11:41:10 +0200
Message-Id: <1250674870.7583.334.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 10:38 +0100, David Howells wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > which implies to me that spin_is_locked() will always return false.  Is this
> > > expected behavior.
> > 
> > That's wrong. spin_is_locked should always return true on UP.
> 
> Surely it's not that simple?  Maybe spin_is_lock() should be undefined on UP.

#define spin_is_locked(l) panic()

should sort things out quickly ;-)
