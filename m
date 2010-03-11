Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0CKOGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:06:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:56128 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab0CKOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:06:29 -0500
Date: Thu, 11 Mar 2010 11:06:15 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Make printing table easily
Message-ID: <20100311140615.GD28421@ghostprotocols.net>
References: <1268034910-12544-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100311125126.GI31354@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311125126.GI31354@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 11, 2010 at 01:51:26PM +0100, Ingo Molnar escreveu:
> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > Hi,
> > 
> > Making table of matrix by printf is painful work,
> > but it can be found in perf here and there.
> > So I'd like to propose semi-automation of making table.
> > New files util/table.c provides stuffs for easy table printing.
> 
> Looks quite reasonable in theory. I suspect it would be useful to see a few 
> table printing places converted to this facility, to see the simplification 
> factor in practice.

I'm going thru the printing routines now to get them usable by TUI/GUIs,
starting with a libnewt based browser integrating initially report and
annotate, after I get the first patch in shape for merging I'll revisit
this table class of yours :-)

- Arnaldo
