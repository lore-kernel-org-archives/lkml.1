Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYAOKZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYAOKZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYAOKZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:25:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:48107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYAOKZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:25:26 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] [13/31] CPA: Use macros to modify the PG_arch_1 page flags in change_page_attr
Date: Tue, 15 Jan 2008 11:25:22 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
References: <200801141116.534682000@suse.de> <200801151106.41855.ak@suse.de> <1200392102.16794.26.camel@brick>
In-Reply-To: <1200392102.16794.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151125.22817.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 11:15:02 Harvey Harrison wrote:
> On Tue, 2008-01-15 at 11:06 +0100, Andi Kleen wrote:
> > On Tuesday 15 January 2008 10:29:51 Harvey Harrison wrote:
> > > On Mon, 2008-01-14 at 23:16 +0100, Andi Kleen wrote:
> > > > Instead of open coding the bit accesses uses standard style
> > > > *PageDeferred* macros. 
> > > > 
> > > 
> > > Any reason these couldn't be static inlines in a shared header?
> > 
> > The whole usage of that bit is private to the file
> 
> True if pageattr_32|64.c get merged, not one I have looked at yet,
> but wouldn't a static inline in the files then be better for the
> typechecking?

If you pass in something other than a struct page * the compiler
will already complain. Also all the other Page* accessor in page-flags.h are macros.

-Andi
