Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIFUJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIFUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFUJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:09:20 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63280 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380AbYIFUJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:09:19 -0400
Date: Sat, 6 Sep 2008 21:08:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
In-Reply-To: <20080906194413.GD23729@lenovo>
Message-ID: <Pine.LNX.4.55.0809062104570.13851@cliff.in.clinika.pl>
References: <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
 <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
 <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
 <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906190446.GA23729@lenovo>
 <86802c440809061216n5bbad56amabf9934f8bf08d57@mail.gmail.com>
 <20080906193820.GC23729@lenovo> <20080906194413.GD23729@lenovo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:

> So I think better would be just use Ingo's suggestion
> about to separate apic/pin iterator and function body.

 No doubt about it.  Then if the number of entries was to be huge, then
lines output to the log buffer could be limited to 80 characters.  With
the use of sprintf() it would be rather trivial.  And you would avoid any
concerns about stack consumption.

 Please note that with MPS 1.1 systems the number of "unconnected" I/O 
APIC inputs can be considerable.

  Maciej
