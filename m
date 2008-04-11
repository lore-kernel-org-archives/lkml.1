Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbYDKQ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbYDKQ76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbYDKQ7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:59:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35912 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441AbYDKQ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:59:46 -0400
In-Reply-To: <20080411135544.GG2160@csclub.uwaterloo.ca>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>
MIME-Version: 1.0
Subject: Re: file offset corruption on 32-bit machines?
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF861D7F24.6F60C82D-ON88257428.005C1DA4-88257428.005D5D80@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 11 Apr 2008 09:59:45 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0.1|February 07, 2008) at
 04/11/2008 12:59:44,
	Serialize complete at 04/11/2008 12:59:44
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>So if you write multithreaded code and don't understand what locking
>around shared resources is for, then your application might break.

I think I know what locking around shared resources is for, which is why 
I'm surprised the kernel doesn't do it.

Is it normal for a kernel resource not to be thread-safe (i.e. you don't 
get advertised/sensible results if two threads access it at the same 
time)?

>Can you give an example where locking is being used correctly where this 
can
>possibly fail?

I could accept (though I haven't thought about it) that there aren't any 
real-world applications that do simultaneous reads and writes through the 
same file pointer.  I might even accept that there can be no useful 
application that does.  But can you say such an application is incorrect?

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

