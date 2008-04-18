Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYDRGLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYDRGLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYDRGLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:11:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYDRGLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:11:12 -0400
Date: Thu, 17 Apr 2008 23:10:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-mm1: not looking good
Message-Id: <20080417231038.72363123.akpm@linux-foundation.org>
In-Reply-To: <20080417224908.67cec814@laptopd505.fenrus.org>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	<20080417224908.67cec814@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 22:49:08 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 17 Apr 2008 16:03:31 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > I repulled all the trees an hour or two ago, installed everything on
> > an 8-way x86_64 box and:
> > 
> > 
> > stack-protector:
> > 
> > Testing -fstack-protector-all feature
> > No -fstack-protector-stack-frame!
> > -fstack-protector-all test failed
> 
> do you have a stack-protector capable GCC? I guess not.
> 
> This is a catch-22. You do not have stack-protector. Should we make that 
> a silent failure? or do you want to know that you don't have a security
> feature you thought you had.... complaining seems to be the right thing to do imo.

A #warning sounds more appropriate.
