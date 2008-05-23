Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYEWQkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYEWQkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYEWQkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:40:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYEWQj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:39:59 -0400
Date: Fri, 23 May 2008 12:39:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: Nick Andrew <nick@nick-andrew.net>
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] debug printk infrastructure
Message-ID: <20080523163922.GA21027@redhat.com>
References: <20080522211331.GA28070@redhat.com> <20080523002101.GC13280@tull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523002101.GC13280@tull.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 10:21:01AM +1000, Nick Andrew wrote:
> If you write "enable all" to the debugfs file and then insmod a new
> module, will debugging be enabled on the new module?
> 

currently, no. i did it that way to make the implementation simpler.

however, i think the "enable all" should enable debugging for a subsequent
'insmod'. added to the todo list.

thanks,

-Jason
