Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYAJJHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYAJJHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYAJJGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:06:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48362 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbYAJJGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:06:23 -0500
Date: Thu, 10 Jan 2008 09:06:21 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]  Add a simple backtrace test module
Message-ID: <20080110090621.GA12738@infradead.org>
References: <20080109224208.541a659f@laptopd505.fenrus.org> <20080110083934.GC10745@infradead.org> <20080110090429.GA23878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110090429.GA23878@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:04:29AM +0100, Ingo Molnar wrote:
> yeah, agreed, we'll clean this all up, and move the other testcode there 
> too, ok? There's rcutorture, lock-selftests, rt-tester, 
> kprobes-smoke-test and now backtracetest.
> 
> Arjan might as well want to use the opportunity and break new kernel 
> namespace ground by creating the tests/ directory for the first time in 
> Linux history and introduce tests/backtracetest.c :-)

Yeah, I'm happy to volunteer Arjan for creating test/ and moving the
existing one there :)

