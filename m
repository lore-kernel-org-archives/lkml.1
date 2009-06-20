Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZFTAtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZFTAtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 20:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZFTAtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 20:49:00 -0400
Received: from fifo99.com ([67.223.236.141]:44789 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZFTAs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 20:48:59 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
In-Reply-To: <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2009 17:49:00 -0700
Message-Id: <1245458940.32124.45.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 17:13 -0700, Arve Hjønnevåg wrote:
> 
> > Also are there any userspace test cases
> > that Google used to test the performance of this interface. Or test
> > cases to compare the binder with something like sockets, or any other
> > type of IPC?
> >
> > If Google believes the binder is the right solution for IPC, how was
> > that conclusion formed?
> >
> > Daniel
> 
> These are mostly questions for the framework team. The binder driver
> is there to support our user space code. At some point we used the
> driver from www.open-binder.org, but we ran into, and fixed, a lot of
> bugs (especially when processes died), so we determined it would be
> faster to rewrite the driver from scratch.

Most of these questions related to the fact that I don't think an
interface like this just slips into the kernel as a driver. Since it's
IPC, it's totally generic, and it's not part of a standard (i.e. POSIX),
we need to have some better and more specific information about it (or
atleast I do). 

If for instance the main reason for Google using this interface is cause
a large number of android people once worked at Palm or BeOS, that's not
reason enough for it to go into the kernel. Or if this binder interface
really fits well with Java or C++ people and they just love it, that's
not really acceptable either..

Daniel

