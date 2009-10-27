Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZJ0KfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZJ0KfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZJ0KfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:35:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42078 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753221AbZJ0KfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:35:02 -0400
Date: Tue, 27 Oct 2009 10:36:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: J K Rai <jk.anurag@yahoo.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Instantaneous snapshot of CPU schedule
Message-ID: <20091027103632.2b6db019@lxorguk.ukuu.org.uk>
In-Reply-To: <256042.70547.qm@web94710.mail.in2.yahoo.com>
References: <256042.70547.qm@web94710.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 13:14:34 +0530 (IST)
J K Rai <jk.anurag@yahoo.com> wrote:

> Hello
> 
> Is there any utility using which we can take current (instantaneous) snapshot of process schedule on the linux based system from user land. Like use a system call or command to know what is running on each of the cpus 0..n-1 (assuming n cpus in the system). Output could be like tuple (pid, cpu_no).
> 
> If such utility does not exist then kindly throw some light / ideas so that it could be implemented.

I'm not sure it would be terribly useful. You know what is running on at
least one of the processors - your snapshot tool. So for uniprocessor its
100% useless, for dual processor 50% useless.

It would also be incredibly expensive to serialize everything on the
system just to take a measurement.
