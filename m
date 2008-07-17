Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYGQW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYGQW4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYGQW4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:56:15 -0400
Received: from isilmar.linta.de ([213.133.102.198]:54106 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076AbYGQW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:56:14 -0400
Date: Fri, 18 Jul 2008 00:56:11 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Greg KH <greg@kroah.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080717225611.GA27481@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Greg KH <greg@kroah.com>, Jason Baron <jbaron@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, nick@nick-andrew.net, randy.dunlap@oracle.com
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717223222.GA28016@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 17, 2008 at 03:32:22PM -0700, Greg KH wrote:
> > that is correct. any callers of dev_dbg() don't have to do anything. its really
> > only the more complex debugging, where there are flags or levels that need to
> > make adjustments to work with the new infrastructure.
> 
> For this reason alone, I see no reason why your patch should not be
> merged today.  You don't need the other subsystems at this point in time
> in my opinion, it's benifit is huge already.

not to object to this statement, but:

what about the user-visible interface? currently, it's based around one big
debugfs file. What about doing

	<debugfs>/dynamic_printk/<module_name>/{enabled[,level][,flag][,modules]}

instead, or even

	<sysfs>/module/<module_name>/debug/{enabled[,level][,flag]}

For "shared" modules like cpufreq (only user so far, AFAICS), things might
get a bit more interesting, but we found that out already in the other
thread ;)

Best wishes,
	Dominik
