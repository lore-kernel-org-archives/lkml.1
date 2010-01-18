Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394Ab0ARRMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0ARRMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0ARRMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:12:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0ARRMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:12:44 -0500
Date: Mon, 18 Jan 2010 19:11:48 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118171148.GB22111@redhat.com>
References: <20100118133755.GG30698@redhat.com>
 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
 <20100118141938.GI30698@redhat.com>
 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
 <1263826198.4283.600.camel@laptop>
 <20100118150159.GB14345@redhat.com>
 <1263827194.4283.609.camel@laptop>
 <4B547A31.4090106@redhat.com>
 <1263827683.4283.610.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263827683.4283.610.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:14:43PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 17:11 +0200, Avi Kivity wrote:
> > On 01/18/2010 05:06 PM, Peter Zijlstra wrote:
> > > On Mon, 2010-01-18 at 17:01 +0200, Gleb Natapov wrote:
> > >    
> > >> There are valid uses for mlockall()
> > >>      
> > > That's debatable.
> > >
> > >    
> > 
> > Real-time?
> 
> I would not advice that, just mlock() the text and data you need for the
> real-time thread. mlockall() is a really blunt instrument.
> 
Yes it is blunt, but the patch makes it less so.

--
			Gleb.
