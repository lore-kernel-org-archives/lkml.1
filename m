Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYBKSC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYBKSC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYBKSCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:02:52 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYBKSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:02:51 -0500
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, haveblue@us.ibm.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080211175425.GA28300@kroah.com>
References: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
	 <20080211175425.GA28300@kroah.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:05:36 -0800
Message-Id: <1202753136.25604.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 09:54 -0800, Greg KH wrote:
> On Mon, Feb 11, 2008 at 09:23:18AM -0800, Badari Pulavarty wrote:
> > Hi Andrew,
> > 
> > While testing hotplug memory remove against -mm, I noticed
> > that unregister_memory() is not cleaning up /sysfs entries
> > correctly. It also de-references structures after destroying
> > them (luckily in the code which never gets used). So, I cleaned
> > up the code and fixed the extra reference issue.
> > 
> > Could you please include it in -mm ?
> 
> Want me to add this to my tree and send it in my next update for the
> driver core to Linus?
> 
> I'll be glad to do that.
> 
> thanks,
> 
> greg k-h

Please do. Only reason I wanted to push through -mm is, I didn't
test this with mainline (since I have patches in -mm for hotplug 
memory remove).

Thanks,
Badari

