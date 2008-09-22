Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYIVXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYIVXjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYIVXjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:39:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:56159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbYIVXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:39:08 -0400
Date: Mon, 22 Sep 2008 16:39:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/2] corruption check: run the corruption checks from a
 work queue
Message-ID: <20080922163914.2cafd797@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0809221627290.4768@shark.he.net>
References: <20080920203544.53a5148e@infradead.org>
	<20080922140402.166de1ba@infradead.org>
	<20080922140503.5f3a3db3@infradead.org>
	<20080922162426.2a55a722@infradead.org>
	<Pine.LNX.4.64.0809221627290.4768@shark.he.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 16:28:23 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Mon, 22 Sep 2008, Arjan van de Ven wrote:
> 
> > eh a stray debug // snuck in; update attached
> 
> In that case, patch 1/2 contains "for(" and "while(".  :(
> 

that's a dillema case.
I'm just moving code around in patch 1/2; I personally consider it bad
form to also change it at the same time.....

(and it confuses git change tracking)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
