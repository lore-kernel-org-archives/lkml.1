Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYKBUfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYKBUfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYKBUfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:35:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:37983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYKBUfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:35:31 -0500
Date: Sun, 2 Nov 2008 12:35:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Alok N Kataria <akataria@vmware.com>, Robert Hancock <hancockr@shaw.ca>,
       Pavel Machek <pavel@suse.cz>
Subject: Re: upstream regression (IO-APIC?)
Message-ID: <20081102123559.3fc6c33d@infradead.org>
In-Reply-To: <200811022124.24992.bzolnier@gmail.com>
References: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no>
	<4909011F.1050102@shaw.ca>
	<200811021537.24771.bzolnier@gmail.com>
	<200811022124.24992.bzolnier@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008 21:24:24 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> The quick fix would be to replace 1000 / HZ by the magic number "4"
> but the major question is whether can we reliably depend on the
> tsc_khz for lpj?
 
I said I didn't like it before, and I still don't....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
