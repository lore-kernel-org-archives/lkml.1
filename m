Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYJIKq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYJIKq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYJIKqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:46:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbYJIKqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:46:49 -0400
Date: Thu, 9 Oct 2008 12:53:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de,
       andi@firstfloor.org
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081009105305.GF24560@one.firstfloor.org>
References: <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why don't you use the ring-buffer tracing engine?

Because he doesn't actually need a ring buffer, it's a snapshot in
time.

> You will really make your life better by putting it as a tracer in
> kernel/trace and by using the relevant API.
> That will avoid you to manage the debugfs things, the memory
> allocation, the buffer managment.....

ftrace-of-bork wants to assimilate everything?

-Andi

-- 
ak@linux.intel.com
