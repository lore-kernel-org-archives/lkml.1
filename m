Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbZBYWkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbZBYWkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZBYWkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:40:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:47603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbZBYWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:40:21 -0500
Subject: Re: [PATCH] Make exported headers use strict posix types
From: David Woodhouse <dwmw2@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
       Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <49A5C118.3070605@zytor.com>
References: <20090225032553.GD6690@bombadil.infradead.org>
	 <200902251917.49017.arnd@arndb.de>
	 <20090225201131.GA26110@uranus.ravnborg.org>
	 <200902252258.30489.arnd@arndb.de>  <49A5C118.3070605@zytor.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 07:39:46 +0900
Message-Id: <1235601586.4913.9.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 14:07 -0800, H. Peter Anvin wrote:
> Arnd Bergmann wrote:
> > 
> > Actually, this change does belong in here: This is the only user of u_short
> > in exported headers, and nothing uses u_char, u_int or u_long, so it gets
> > rid of a whole class of types. The only questionable types left after this
> > are the standard stdint.h types, many of which are probably legitimate:
> > 
> 
> Not legitimate in *exported* headers.

Not in the ones which might be included implicitly by glibc, perhaps --
but other non-POSIX headers are perfectly entitled to require C standard
types, surely?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

