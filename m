Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0BOQP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:15:58 -0500
Received: from mail.codeweavers.com ([216.251.189.131]:34378 "EHLO
	mail.codeweavers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0BOQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:15:57 -0500
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 11:15:56 EST
From: Alexandre Julliard <julliard@winehq.org>
To: prasad@linux.vnet.ibm.com
Cc: Michael Stefaniuc <mstefani@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere>
	<4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com>
	<4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere>
	<4B785952.8020706@redhat.com> <20100214204130.GD5479@nowhere>
	<4B7881AC.5070209@redhat.com> <20100215115713.GA8907@in.ibm.com>
Date: Mon, 15 Feb 2010 16:57:08 +0100
In-Reply-To: <20100215115713.GA8907@in.ibm.com> (K. Prasad's message of "Mon,
	15 Feb 2010 17:27:13 +0530")
Message-ID: <87ljeutru3.fsf@wine.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> We could change this to become 'local' for every local request (but still
> cleanup the breakpoints using scheduler hooks like the way we presently
> do), but I think this is an implementation detail and that a ptrace user
> need not worry about it. Or do you believe that there's any?
>
> I'm afraid I don't understand your motivation for these read/write tests
> on debug control register? Such tests, as in this case, cause unnecessary
> panic due to changes in an implementation detail internal to the kernel
> without any perceptible difference in functionality.

Various copy protection schemes such as Safedisc do all sorts of strange
manipulations and checks on the debug registers, in an attempt to make
sure that the app is not being run under a debugger. The Wine exception
tests try to replicate that behavior.

-- 
Alexandre Julliard
julliard@winehq.org
