Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZDVWVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZDVWVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZDVWV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:21:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56481 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbZDVWV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:21:29 -0400
Date: Thu, 23 Apr 2009 00:17:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>, jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org
Subject: PT_DTRACE && uml
Message-ID: <20090422221726.GC22755@redhat.com>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com> <20090408203954.GA26816@redhat.com> <20090416204004.GA28013@redhat.com> <20090416232430.4DAE4FC3C6@magilla.sf.frob.com> <20090420183718.GC32527@redhat.com> <20090421011354.4B19EFC3C7@magilla.sf.frob.com> <20090421214819.GA22845@redhat.com> <20090422032205.B8D39FC3C7@magilla.sf.frob.com> <20090422220400.GA22755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422220400.GA22755@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Jeff Dike)

So, arch/um/ seems to be the only user of PT_DTRACE.

I do not understand this code at all. It looks as if we can just
s/PT_DTRACE/TIF_SINGLESTEP/.

But it can't be that simple?

Oleg.

