Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbXFYBoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbXFYBoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXFYBos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:44:48 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:40642 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbXFYBos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:44:48 -0400
Message-ID: <467F1D34.5080807@gmail.com>
Date: Mon, 25 Jun 2007 03:41:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: david@lang.hm
CC: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Benjamin LaHaise <bcrl@kvack.org>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
References: <467cac85.081b600a.5b88.457f@mx.google.com>  <E1I20Wr-00064i-T0@flower>  <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>  <20070624222518.GA10398@flower.upol.cz>  <1182723318.6819.5.camel@laptopd505.fenrus.org>  <20070624232314.GA971@kvack.org>  <1182730156.6819.8.camel@laptopd505.fenrus.org>  <20070625001203.GB971@kvack.org>  <1182731022.6819.10.camel@laptopd505.fenrus.org>  <20070625004106.GA1094@stusta.de>  <1182733127.6819.13.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 03:33 AM, david@lang.hm wrote:

> is the list of what's included in -O2 vs -Os different for different 
> CPU's? what about within a single family of processors? (even in the x86 
> family the costs of jumps, loops, and cache misses varies drasticly)

At least not in the example Duron/Athlon case. Both -march=athlon{,-4) but 
64K versus 256K L2 which I'd expect to be an important difference in the -Os 
versus -O2 behaviour.

Rene.
