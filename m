Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZDWQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZDWQC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZDWQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:02:46 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:39423 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZDWQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:02:45 -0400
Date: Thu, 23 Apr 2009 12:02:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PT_DTRACE && uml
Message-ID: <20090423160229.GA9820@c2.user-mode-linux.org>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com> <20090408203954.GA26816@redhat.com> <20090416204004.GA28013@redhat.com> <20090416232430.4DAE4FC3C6@magilla.sf.frob.com> <20090420183718.GC32527@redhat.com> <20090421011354.4B19EFC3C7@magilla.sf.frob.com> <20090421214819.GA22845@redhat.com> <20090422032205.B8D39FC3C7@magilla.sf.frob.com> <20090422220400.GA22755@redhat.com> <20090422221726.GC22755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422221726.GC22755@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 12:17:26AM +0200, Oleg Nesterov wrote:
> (cc Jeff Dike)
> 
> So, arch/um/ seems to be the only user of PT_DTRACE.
> 
> I do not understand this code at all. It looks as if we can just
> s/PT_DTRACE/TIF_SINGLESTEP/.
> 
> But it can't be that simple?

It looks like it.  The one odd part is the use in the signal delivery
code.  That looks like a bug to me.

				Jeff
