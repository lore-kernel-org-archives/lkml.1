Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZDWFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZDWFNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZDWFNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:13:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbZDWFNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:13:13 -0400
Date: Wed, 22 Apr 2009 22:11:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Venky Venkatesh (venky)" <venky@cisco.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Proc entry to know task/thread sleep time
Message-Id: <20090422221141.d57a3dc0.akpm@linux-foundation.org>
In-Reply-To: <9E88C8678BF34240A8C61D4078A3D251F7940F@xmb-sjc-23e.amer.cisco.com>
References: <9E88C8678BF34240A8C61D4078A3D251F7940F@xmb-sjc-23e.amer.cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 12:41:45 -0700 "Venky Venkatesh (venky)" <venky@cisco.com> wrote:

>  
> Hi,
> I am looking for any proc entry/tool which would provide the time for
> which a thread/task has been sleeping. The use of this is the following:
> I have a multi-threaded application and I am trying to determine the
> extent of multi-processing between threads i.e. determine how much time
> threads spend on blocking for resources/each other Vs doing productive
> work. 
> If the above is available, is there an additional info on
> time-waiting-on-io (i.e. a subset of the above sleep time) that is also
> available thru a proc entry/tool? This would find use in a server like
> application where if all the current threads are spending most of their
> time waiting on I/O then can add more threads.
> In general if there is a proc entry which accounts for time spent by a
> thread in various states that could also help.
> 	 

Do Documentation/accounting/delay-accounting.txt and
Documentation/accounting/getdelays.c suit?
