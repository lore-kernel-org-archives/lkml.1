Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbXHNIhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbXHNIhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXHNIhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:37:15 -0400
Received: from mx1.suse.de ([195.135.220.2]:34262 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXHNIhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:37:13 -0400
Date: Tue, 14 Aug 2007 10:37:10 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: vgoyal@in.ibm.com, Keith Owens <kaos@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070814083710.GA14538@suse.de>
Mail-Followup-To: Takenori Nagano <t-nagano@ah.jp.nec.com>,
	vgoyal@in.ibm.com, Keith Owens <kaos@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46C1691E.7090708@ah.jp.nec.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Takenori Nagano <t-nagano@ah.jp.nec.com> [2007-08-14 10:34]:
> Vivek Goyal wrote:
> > On Fri, Aug 03, 2007 at 02:05:47PM +1000, Keith Owens wrote:
> > 
> > 
> > To sum up, couple of options come to mind.
> > 
> > - Register all the RAS tools on die notifier and panic
> >   notifier lists with fairly high priority. Export list
> >   of RAS tools to user space and allow users to decide the
> >   order of execution and priority of RAS tools.
> > 
> > - Create a separate RAS tool notifier list (ras_tool_notifer_list).
> >   All the RAS tools register on this list. This list gets priority
> >   over die or panic notifier list. User decides the oder of execution
> >   of RAS tools. 
> > 
> >   Here assumption is that above list will not be exported to modules.
> >   All the RAS tools will be in kernel and they always get a priority
> >   to inspect an event.
> > 
> > What do others think?
> 
> Very good idea. But there is a problem how to give default priority to RAS tools.
> 
> How about priority changeable notifier_list? User can change list order
> dynamically if they want. Of course, we have to give highest priority to kdump
> by default. It is very useful for users who want to use some RAS tools.

I think that was the idea of the first “-” (“export list of RAS tools
to user space”).


Thanks,
   Bernhard
