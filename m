Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXLKBKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXLKBKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXLKBJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:09:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39006 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXLKBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:09:51 -0500
Date: Mon, 10 Dec 2007 17:06:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210170650.0026ad01@laptopd505.fenrus.org>
In-Reply-To: <20071211010125.75e2e807@inria.fr>
References: <200712080340.49546.rjw@sisk.pl>
	<20071210204212.GA5502@elte.hu>
	<20071210125923.37bd2f10.akpm@linux-foundation.org>
	<20071210224508.GB27178@elte.hu>
	<20071210230425.GA641@elte.hu>
	<20071211003433.5cf0230d@morte>
	<20071210155611.512ab381@laptopd505.fenrus.org>
	<20071211010125.75e2e807@inria.fr>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 01:01:25 +0100
Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > the frequency of both cores is the maximum of what linux sets each
> > core to;
> 
> Do you mean that the cpufreq code can be confused about the actual
> frequency of the cores? 

it means that cpufreq doesn't know the actual frequency (although bios sometimes tells us about the relationship, often the bios just lies through it's teeth); it only knows what it asks for, not what it gets. We know it'll get at least what it asks for, but it can get more than it asks for basically.

>That sounds like a big problem.

it'll get way worse going forward.
(but even on todays systems, the tsc no longer represents frequency, but is some fixed clock totally unrelated to cpu frequency)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
