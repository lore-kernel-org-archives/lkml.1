Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbXGQB3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbXGQB3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXGQB27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:28:59 -0400
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:33210 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757662AbXGQB26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:28:58 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 21:28:58 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: panics with 16port Promise Supertrack EX Controller
Date: Mon, 16 Jul 2007 18:26:39 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F038973BD@nonameb.ptu.promise.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: panics with 16port Promise Supertrack EX Controller
Thread-Index: AcfHm3EBZ87JaolnS7G/tDlw0+B/FQAcfG6g
From: "Ed Lin" <ed.lin@promise.com>
To: "Jens Axboe" <jens.axboe@oracle.com>, "Flavio Curti" <fcu@no-way.org>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Flavio Curti" <lists.fcu@no-way.org>, <linux-kernel@vger.kernel.org>,
       "Promise_Linux" <Promise_Linux@promise.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Monday, July 16, 2007 4:18 AM
> To: Flavio Curti
> Cc: Nick Piggin; Michal Piotrowski; Flavio Curti; 
> linux-kernel@vger.kernel.org; Promise_Linux
> Subject: Re: panics with 16port Promise Supertrack EX Controller
> 
> 
> On Sun, Jul 15 2007, Flavio Curti wrote:
> > Hello
> > 
> > On Mon, Jul 09, 2007 at 11:59:36AM +1000, Nick Piggin wrote:
> > > >Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   
> > > >(2.6.22-rc7-dorade #1)
> > > >>The machine panics
> > > >>after some days of running fine, the machine inst heavy loaded.
> > > >>The Controller detects as stex device:
> > > >kernel BUG at block/as-iosched.c:1084!
> > > >
> > > >BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
> > > Could be a bug in the driver that just happens to be 
> caught by AS checks.
> > > If you could test another scheduler (boot with 
> elevator=deadline or 
> > > elevator=cfq),
> > > it might help give us an idea.
> > 
> > Ok, I now switched to cfg, and the machine panicd again. 
> Panic attached.
> > Any help is appreciated.
> 
> It really looks like a stex bug - perhaps it's doing double 
> completions
> of a request?
> 


I will come up with something related to tag lock, and see
what happens after that.

Ed Lin
