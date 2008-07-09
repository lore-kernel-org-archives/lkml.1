Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYGIEvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYGIEvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYGIEug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:50:36 -0400
Received: from ozlabs.org ([203.10.76.45]:47358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbYGIEud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:50:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Date: Wed, 9 Jul 2008 12:18:56 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Jason Baron" <jbaron@redhat.com>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807082311.35793.rusty@rustcorp.com.au> <961aa3350807080802w7e6acef9g4e931e26b3061d7e@mail.gmail.com>
In-Reply-To: <961aa3350807080802w7e6acef9g4e931e26b3061d7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091218.57205.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008 01:02:02 Akinobu Mita wrote:
> 2008/7/8 Rusty Russell <rusty@rustcorp.com.au>:
> > On Tuesday 08 July 2008 21:44:40 Akinobu Mita wrote:
> >> I found a small possible cleanup in this patch.
> >
> > Well spotted!  I think this cleanup is actually orthogonal to my patch,
> > so best served as a separate patch, how's this?
>
> Actually the cpu_online() check was necessary before appling this
> stop_machine: simplify patch.
>
> With old __stop_machine_run(), __stop_machine_run() could succeed
> (return !IS_ERR(p) value) even if take_cpu_down() returned non-zero value.
> The return value of take_cpu_down() was obtained through kthread_stop().

Ah, thanks for the analysis!

It's a little non-obvious, so I've left it as a separate patch (it doesn't 
hurt to have the check there), but included your excellent explanation within 
it.

Thanks!
Rusty.
