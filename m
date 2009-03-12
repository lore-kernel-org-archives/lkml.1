Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZCLVYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZCLVYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZCLVYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:24:16 -0400
Received: from phunq.net ([64.81.85.152]:38528 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754038AbZCLVYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:24:16 -0400
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 14:24:08 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090311230713.d4710050.akpm@linux-foundation.org> <87zlfqeuwr.fsf@basil.nowhere.org>
In-Reply-To: <87zlfqeuwr.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121424.08961.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Andi Kleen wrote:
> to be honest the estimate of adding btree directories in 3kLOC
> of code seems very optimistic.

Is that a bet?

> >> This symbol is only supposed to be shared between separate compilation
> >> units within fs/tux3, not be visible outside our module.  How do we do
> >> that?
> >
> > You can't.  Bear in mind that we want the allyesconfig kernel to link
> > and run, and that includes tux3.  So do it manually by prefixing
> > everything with tux3_ or whatever.  (does it need the "3"?)
> 
> AFAIK it could be done by using special linker scripts for the sublinks.
> But I'm not sure it's worth it because that would require listing of the symbols
> in some file. Would need some Makefile magic.
> 
> For modules I also had the "namespace" patches some time ago which implemented
> simple namespace support. Should probably resurrect that.

Per-module name scope would be a nice creature comfort.  Well, for now
the offending names will just get tux_ed.

Regards,

Daniel
