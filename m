Return-Path: <linux-kernel-owner+w=401wt.eu-S934180AbXC0StK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180AbXC0StK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934179AbXC0StK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:49:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54957 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934180AbXC0StJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:49:09 -0400
Date: Wed, 28 Mar 2007 00:19:21 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Ethan Solomita <solo@google.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Martin Bligh <mbligh@google.com>, Rohit Seth <rohitseth@google.com>,
       viro@ftp.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs reclaim crash
Message-ID: <20070327184921.GA2057@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20070319140238.cbf28b2b.akpm@linux-foundation.org> <20070321134654.5wkqpfbpk0ggwks8@imap.linux.ibm.com> <20070321182123.GA12602@in.ibm.com> <20070323043047.GA5641@in.ibm.com> <20070322210504.3b052139.akpm@linux-foundation.org> <46042DDF.5060000@google.com> <20070324030535.GA8874@in.ibm.com> <46096202.6080205@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46096202.6080205@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 11:27:14AM -0700, Ethan Solomita wrote:
> 	Hi Maneesh -- I will start testing with the patch you provided. If 
> 	you come up with any further issues please let me know. Also, if you could 
> suggest some additional BUG() lines that I could insert I would 
> appreciate it. Since the bug is hard to reproduce, it may be easier to 
> catch a race condition in the making via BUG() than an actual failure 
> due to a race condition.
> 

Hi Ethan,

Thanks for testing. The BUG_ON in sysfs_d_iput() is still there to catch
the first race we saw. And the second one should not occur as now we are not
using the s_dentry in sysfs_readdir(). 

Regards,
Maneesh

--
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
