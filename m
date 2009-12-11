Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZLKULR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZLKULR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZLKULL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:11:11 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:19894 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZLKULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:11:11 -0500
Date: Fri, 11 Dec 2009 12:08:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr@ravnborg.org
Subject: Re: hwrng: virtio - Rename driver object to remove section mismatch
 warning
Message-Id: <20091211120849.012c43d8.randy.dunlap@oracle.com>
In-Reply-To: <1260559557.24459.1320.camel@calx>
References: <20091211153658.GA1207@gondor.apana.org.au>
	<1260559557.24459.1320.camel@calx>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4B22A71B.011F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 13:25:57 -0600 Matt Mackall wrote:

> On Fri, 2009-12-11 at 23:36 +0800, Herbert Xu wrote:
> > Hi:
> > 
> > Finally found the cause of the section mismatch warning in hwrng.
> > Apparently in addition to __devexit_p we now have to name the
> > variable in a certain way.
> 
> That's fairly appalling. Any idea why?

(I haven't read the rest of this thread..)

scripts/mod/modpost.c looks for certain variable names to identify
variables that can have references to other (non-data) sections.
It's mostly explained there.

(added cc: Sam)

---
~Randy
