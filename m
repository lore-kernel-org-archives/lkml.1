Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbZHWT3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbZHWT3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 15:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933782AbZHWT3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 15:29:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933763AbZHWT3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:29:09 -0400
Date: Sun, 23 Aug 2009 21:32:24 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xenfb: connect to backend before registering fb
Message-ID: <20090823213224.25d14614@leela>
In-Reply-To: <4A8F2392.8000101@goop.org>
References: <20090821124059.17ab93fa@leela>
	<20090821150922.72e12d9a@leela>
	<20090821151352.1676de18@leela>
	<20090821154407.6337421b@leela>
	<4A8F2392.8000101@goop.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Fri, 21 Aug 2009 15:45:38 -0700 Jeremy Fitzhardinge napsal(a):
> On 08/21/09 06:44, Michal Schmidt wrote:
> > As soon as the framebuffer is registered, our methods may be called
> > by the kernel. This leads to a crash as xenfb_refresh() gets called
> > before we have the irq.
> >
> > Connect to the backend before registering our framebuffer with the
> > kernel. 
> 
> Thanks, applied.  Should this be backported to stable?

Yes, it should go to stable too. 2.6.30.x needs it and it applies
cleanly.

Michal
