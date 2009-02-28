Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZB1MQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZB1MQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZB1MQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:16:31 -0500
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:47553 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751163AbZB1MQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:16:31 -0500
X-Yahoo-Newman-Id: 916647.87135.bm@omp417.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0zZnuST/1w7kOwTVJodTuKxcHGlf61C1PKmsRbbbSPsiwovnWDGTWZVVikD1KBnA5TVYJ90v68Xh5ObYlwuwAFYAB6XLy9weauTMxLdRSNWFGfMTwur7aspKdoUiG2wG9PDRyx2kLIV5lCp1cql3l7H5dT1Z/a5tJm0n2MkIlcI=  ;
X-YMail-OSG: .USTwHIVM1kdSDXtIll.y.tZRAGXzfwtFDxB23A9Pus.SI484uVD7FlVqEwTmEMrPmQbmulC.7KOpFKAo6VG6vbOTRWJueJCTPpVwDLnXzZnItNewldJGGsbmK6uExCXCXJAc_.zatEyLryXpOC4.ztz70F75rf3f3lqpWr3KvJulxEcrpqTi7GO4lpO
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Sat, 28 Feb 2009 04:16:26 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902272046.50572.david-b@pacbell.net> <alpine.LFD.2.00.0902281208270.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902281208270.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902280416.26687.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Thomas Gleixner wrote:
> On Fri, 27 Feb 2009, David Brownell wrote:
> >   drivers/mfd/twl4030-irq.c
> > 
> > Where you'll observe twl_init_irq() at line 688 setting
> > up the thread and the Primary IRQ Handler (PIH) dispatch.
> > That's pretty much bog-standard chained IRQ setup code,
> > except that it chains through a thread.
> 
> So this would be the perfect candidate to test the generic threaded
> code I posted a few days ago ?

Could be.  URL?


