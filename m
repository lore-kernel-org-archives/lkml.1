Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXI1Ogq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXI1Ogq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbXI1Ogi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:36:38 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:35259 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbXI1Ogh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:36:37 -0400
Date: Fri, 28 Sep 2007 16:36:34 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Rik van Riel <riel@redhat.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Daniel =?ISO-8859-1?B?U3Dlbmc=?= <daniel.spang@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory management in embedded systems
Message-Id: <20070928163634.d7fc8909.dada1@cosmosbay.com>
In-Reply-To: <20070928101711.504eb198@bree.surriel.com>
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	<Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	<cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	<Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
	<20070928101711.504eb198@bree.surriel.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:17:11 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Fri, 28 Sep 2007 10:04:23 -0400
> "linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:
> > On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> > 
> > > On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> > >>
> > >> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> 
> > >>> Some kind of notification to the application that the available memory
> > >>> is scarce and let the application free up some memory (e.g., by
> > >>> flushing caches), could be used to improve the situation 
> 
> > Any networked appliance can (will) throw data away if there are
> > no resources available.
> 
> That is exactly what Daniel proposed in his first email.
> 
> I think his idea makes sense.

IBM AIX uses SIGDANGER, that kernel can raise in OOM conditions to warn
processes that are willing to handle this signal (default action for the
 SIGDANGER signal is to ignore the signal)

