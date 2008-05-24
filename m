Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbYEXQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbYEXQeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 12:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbYEXQeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 12:34:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59515 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYEXQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 12:34:14 -0400
Date: Sat, 24 May 2008 09:33:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: some numbers on macros
Message-ID: <20080524093350.60e6dc8d@infradead.org>
In-Reply-To: <200805241748.19607.m.kozlowski@tuxland.pl>
References: <200805241748.19607.m.kozlowski@tuxland.pl>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 17:48:19 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	I wrote a rather dumb script to see some numbers on macros I
> was interested in. The script basically parses *.c file, finds macro
> definitions and counts how many times each macro was used in this
> source file. The script doesn't see any context so it can produce
> false positives - that is one of the reasons it doesn't look into
> header files - it's simply too dumb.
> 
> The macros I was interested in were these which are:
> - defined and unused
> - defined and used only once
> - defined more than once
> 
> I dont want to start another cleanup-patches-storm so first I'd like
> to know if this excersise is worth it as unused macros do not do much
> harm.
> 
> Would such patches be accepted?

An unused define/macro that was declared in a .c file isn't very
interesting to be honest; that tends to be helper macros for the
developer and removing those is just counter productive.

unused macros in common header files are an indication of stale APIs
otoh.. and might be of some interest. (Same for static inline in
headers)
