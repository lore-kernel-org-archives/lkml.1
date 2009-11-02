Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZKBO0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZKBO0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZKBO0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:26:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:50221 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755217AbZKBO0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:26:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX183dbErs/Y3VQKAWvjL/GVtUvsHVfQnq/Zt7ZikSX
	kyD/TfBivJIMmD
Subject: Re: [PATCH][RFC] Adding benchmark subsystem to perf
From: Mike Galbraith <efault@gmx.de>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, acme@redhat.com,
       fweisbec@gmail.com
In-Reply-To: <20091102.225129.149607581235026541.mitake@dcl.info.waseda.ac.jp>
References: <20091101.131027.680961629714047921.mitake@dcl.info.waseda.ac.jp>
	 <20091102104124.GA5193@elte.hu> <200911022357.36541.rusty@rustcorp.com.au>
	 <20091102.225129.149607581235026541.mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 15:26:09 +0100
Message-Id: <1257171969.8623.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-11-02 at 22:51 +0900, Hitoshi Mitake wrote:

> Example of usage:
> % perf bench sched -t -l 1000
> 2.863

I think this should allow other benchmarks to be added is a logical
manner.  Perhaps perf bench -t hackbench -t -l 1000, ie bench should
process args to allow the user to select a benchmark from a suite, and
pass args to it as well, but with a default set built in so people can
just type perf bench -t foo, to run any benchmark with it's defaults.

	-Mike

