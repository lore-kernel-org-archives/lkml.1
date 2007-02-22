Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXBVJx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXBVJx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXBVJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:53:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbXBVJxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:53:25 -0500
Date: Thu, 22 Feb 2007 04:50:39 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
Message-ID: <20070222095039.GR10425@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD4FA0.5030205@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 12:09:04AM -0800, Jeremy Fitzhardinge wrote:
> Arjan van de Ven wrote:
> > Do we know how many gcc bugs this has? (regparm used to have many)
> > other than that.. sounds like a win...
> >   
> 
> The documentation suggests that its the preferred mode of operation, and
> that its the default on platforms where gcc is the primary compiler.  So
> the fact that it isn't for Linux suggests either an oversight or that it
> is actually broken...

It is used for Linux on many architectures (x86_64, sparc64, ia64,
ppc{,64}, arm, sh, m68k to name just a few), but it is an ABI decision,
so e.g. on i386 is not used by default as the ABI mandates structs/unions
are returned in memory.

	Jakub
