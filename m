Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbXIRRzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbXIRRzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXIRRzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:55:31 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:43087 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbXIRRza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:55:30 -0400
Date: Tue, 18 Sep 2007 13:55:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vara Prasad <prasadav@us.ibm.com>, David Wilder <dwilder@us.ibm.com>,
       linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCH 0/2] A kernel tracing interface
Message-ID: <20070918175521.GA2915@Krystal>
References: <46E9CB0D.2040206@us.ibm.com> <20070914174953.04b0b158.akpm@linux-foundation.org> <46EFFF9D.6090609@us.ibm.com> <46F0026F.7030102@us.ibm.com> <20070918101327.91c5f24f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070918101327.91c5f24f.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:52:09 up 50 days, 18:11,  4 users,  load average: 1.04, 0.59, 0.75
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 18 Sep 2007 09:53:03 -0700 Vara Prasad <prasadav@us.ibm.com> wrote:
> 
> > This is part of the effort by the SystemTap team to move pieces of the 
> > project that are generic to mainline.
> 
> Yeah.  It seems to have been reviewed to death.  Is it ready to
> be applied yet?

I would just say that this could be seen rather as a driver tracing
interface than a general purpose tracing interface. Therefore, maybe the
name is a bit misleading ? And yes, what is there is good, but it does
not seem to be a replacement for a generic kernel tracer.

My suggestions to turn it into a more suitable interface for a generic
tracer are summarized in this email:
http://lkml.org/lkml/2007/9/15/136

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
