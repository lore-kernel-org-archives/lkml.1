Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZKNF0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZKNF0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZKNF0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:26:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1055 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbZKNF0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:26:17 -0500
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
From: Joe Perches <joe@perches.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Wagner <daw-news@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4AFE3C53.70709@schaufler-ca.com>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
	 <4AFCC06B.1030302@schaufler-ca.com>
	 <19857.1258147396@turing-police.cc.vt.edu>
	 <4AFE1EA9.60102@schaufler-ca.com>  <hdl92e$srv$1@taverner.cs.berkeley.edu>
	 <1258170491.16857.142.camel@Joe-Laptop.home>
	 <4AFE3C53.70709@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 21:26:21 -0800
Message-ID: <1258176381.16857.155.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 21:12 -0800, Casey Schaufler wrote: 
> Joe Perches wrote:
> > On Sat, 2009-11-14 at 03:44 +0000, David Wagner wrote:
> >> I personally don't find
> >>     strncmp(foo, "constant", sizeof("constant"))        // first snippet
> >> to be more readable, auditable, or obviously correct than
> >>     strcmp(foo, "constant").                            // second snippet
> >> Is there a technical basis for arguing that the first
> >> snippet is better than the second snippet?
> > I don't think there is.
> And you're exactly correct.
> This whole discussion is around a gratuitous
> change that has no net effect on the behavior of the system.

It has relatively little or no effect on a
running system, but does effect code
readability.

> I am advocating that the code be left as is.

I assert that code should be made as readable
as possible and that the code used fit the
reader's expectations.

strcmp(foo, "BAR") is natural.
strncmp(foo, "BAR", sizeof("BAR")) is unnatural
and should not be used.

cheers, Joe

