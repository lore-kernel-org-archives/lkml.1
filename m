Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXIISdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXIISdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbXIISdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:33:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39205 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204AbXIISda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:33:30 -0400
Date: Sun, 9 Sep 2007 19:31:48 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Dennis Lubert <plasmahh@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: tsc timer related problems/questions
Message-ID: <20070909193148.6372dcc9@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0709092016120.11640@fbirervta.pbzchgretzou.qr>
References: <1189355506.6255.60.camel@speedy.projectiwear.org>
	<20070909174935.7c00bbb7@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0709092016120.11640@fbirervta.pbzchgretzou.qr>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 20:17:28 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Sep 9 2007 17:49, Arjan van de Ven wrote:
> >> 
> >> Question: Why are only Intel CPUs considered as stable? Could
> >> there be implemented a more sophisticated heuristic, that actually
> >> does some tests for tsc stability?
> >
> >on AMD multi-socket systems, afaik the tsc is not synchronized
> >between packages. On Intel the tsc is derived from the FSB which is
> >shared between the packages.
> 
> Also, the TSC is not necessarily constant wrt. CPU clock speed.
> If your program stalls, the core may reduce frequency and hence
> TSC values are not linear to time anymore.
> 

that depends on the CPU generation; most current cpus have
constant-rate tscs (at least constant wrt their own concept of time,
but at least independent of cpu frequency)...

it gets more iffy on idle; on deep idle the tsc tends to stop ;(
