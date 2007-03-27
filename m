Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbXC0THA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbXC0THA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbXC0THA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:07:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934188AbXC0TG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:06:59 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0703271000x2910b2fan573fd37bb45a058d@mail.gmail.com> 
References: <8bd0f97a0703271000x2910b2fan573fd37bb45a058d@mail.gmail.com>  <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI> <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com> <6791.1174909459@redhat.com> <11045.1174911764@redhat.com> <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI> <22674.1174915478@redhat.com> <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com> <27782.1174989913@redhat.com> 
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 27 Mar 2007 20:06:28 +0100
Message-ID: <26771.1175022388@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> > That sounds reasonable.  However, I suspect that most NOMMU CPUs won't be
> > able to do that.  In effect you're creating a third option, I think (MMU,
> > NOMMU, MPU).
> 
> sure, but i'm not sure the MPU option would be mutually exclusive with
> NOMMU ... in the Blackfin case, we'd want both ...

I imagine that MPU would be a superset of NOMMU.

David
