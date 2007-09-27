Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbXI0Wjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbXI0Wjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbXI0Wj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:39:29 -0400
Received: from smtpoutm.mac.com ([17.148.16.68]:56248 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbXI0Wj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:39:28 -0400
In-Reply-To: <20070925225005.GB26099@kroah.com>
References: <11902770971822-git-send-email-htejun@gmail.com> <20070925225005.GB26099@kroah.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9632E683-2521-49F3-8EB6-64D406862831@mac.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCHSET 4/4] sysfs: implement new features
Date: Thu, 27 Sep 2007 18:38:59 -0400
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 25, 2007, at 18:50:05, Greg KH wrote:
> On Thu, Sep 20, 2007 at 05:31:37PM +0900, Tejun Heo wrote:
>> * Name-formatting for symlinks.  e.g. symlink pointing to /dira/ 
>> dirb/leaf can be named as "symlink:%1-%0" and it will show up as  
>> "symlink:dirb-leaf".  This only applies when new interface is used.
>
> Is this really necessary?  It looks like we are adding a "special"  
> type of parser here that no one uses.

IMHO this would be nicer if it could reuse existing sprintf code to  
handle all the nice shiny sprintf format specifiers.  The only  
challenge would be how to dynamically build a varargs list from an  
array of component names although perhaps there could be an internal  
__csprintf function which took a callback for retrieving arguments.   
Also since all of the path components are strings I don't know that  
numeric specifiers could be made useful, so perhaps it's not the  
greatest idea.

I think the primary importance for this functionality is:

>> * Autorenaming of symlinks according to the name format string  
>> when target or one of its ancestors is renamed or moved.  This  
>> only applies when new interface is used.
>
> Nice.

Cheers,
Kyle Moffett

