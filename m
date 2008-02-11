Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYBKR4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYBKR4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYBKR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:56:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56340 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYBKR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:56:25 -0500
Date: Mon, 11 Feb 2008 09:54:25 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, haveblue@us.ibm.com,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
Message-ID: <20080211175425.GA28300@kroah.com>
References: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:23:18AM -0800, Badari Pulavarty wrote:
> Hi Andrew,
> 
> While testing hotplug memory remove against -mm, I noticed
> that unregister_memory() is not cleaning up /sysfs entries
> correctly. It also de-references structures after destroying
> them (luckily in the code which never gets used). So, I cleaned
> up the code and fixed the extra reference issue.
> 
> Could you please include it in -mm ?

Want me to add this to my tree and send it in my next update for the
driver core to Linus?

I'll be glad to do that.

thanks,

greg k-h
