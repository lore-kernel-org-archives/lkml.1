Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXIYB7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXIYB7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 21:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXIYB7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 21:59:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54093 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbXIYB67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 21:58:59 -0400
Date: Tue, 25 Sep 2007 07:39:11 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: roel <12o3l@tiscali.nl>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 4/5] Add fair-user scheduler
Message-ID: <20070925020911.GA26289@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924163326.GA10291@linux.vnet.ibm.com> <20070924164059.GE10291@linux.vnet.ibm.com> <46F84ABB.4030804@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F84ABB.4030804@tiscali.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 01:39:39AM +0200, roel wrote:
> > +static int
> > +root_user_share_read_proc(char *page, char **start, off_t off, int count,
> > +				 int *eof, void *data)
> > +{
> > +	int len;
> > +
> > +	len = sprintf(page, "%d\n", init_task_grp_load);
> > +
> > +	return len;
> > +}
> 
> or use this oneliner:
> 
> 	return sprintf(page, "%d\n", init_task_grp_load);

Looks good. Will fix this in a follow-on.patch.

Thanks!

-- 
Regards,
vatsa
