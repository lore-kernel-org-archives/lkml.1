Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbYGJSUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbYGJSUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbYGJSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:20:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbYGJSU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:20:26 -0400
Date: Thu, 10 Jul 2008 14:18:22 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] simple dprobe like markers for the kernel
Message-ID: <20080710181822.GA20174@redhat.com>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain> <y0m1w22qxoj.fsf@ton.toronto.redhat.com> <1215697794.3353.5.camel@localhost.localdomain> <20080710142208.GC1213@redhat.com> <1215700996.3353.30.camel@localhost.localdomain> <20080710153017.GB25939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710153017.GB25939@mit.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jul 10, 2008 at 11:30:17AM -0400, Theodore Tso wrote:

> [...]  When you said a tool could determine if the tracepoint had
> gotten optimized away, or the variables were no longer present, I
> assume you meant at compile time, right?  So with the right tool
> built into the kbuild infrastructure, if we could simply print
> warnings when tracepoints had gotten optimized away [...]

It will be interesting to see how frequently such a warning appears
for a good suite of such mini markers, on a diversity of architectures
and compilers.  Such data can help pronounce judgement on this approach.


> P.S.  When you said that the current kernel markers are "a bit
> heavyweight", how bad are they in practice?  Hundreds of cycles?  More?

Good question.  The only performance measurements I have seen posted
indicate negligible effects.


- FChE
