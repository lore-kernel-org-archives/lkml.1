Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXD3Kke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXD3Kke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXD3Kj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:39:26 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:10513 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbXD3KjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:39:13 -0400
From: Swen Schillig <swen@vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/scsi/zfcp_erp: Convert to use the kthread API
Date: Mon, 30 Apr 2007 12:41:23 +0200
User-Agent: KMail/1.9.5
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969571980-git-send-email-ebiederm@xmission.com> <20070422201709.GA23015@infradead.org>
In-Reply-To: <20070422201709.GA23015@infradead.org>
Organization: IBM
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301241.23894.swen@vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 22:17, Christoph Hellwig wrote:
> On Thu, Apr 19, 2007 at 01:58:42AM -0600, Eric W. Biederman wrote:
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > Modify zfcperp%s to be started with kthread_run not
> > a combination of kernel_thread, daemonize and siginitsetinv
> > making the code slightly simpler and more maintainable.
> 
> This driver would also benefit from a full kthread conversion.
> Unfortunately it has a strange dual-use semaphore (->erp_ready_sem)
> that hinders a straight conversion.  Maybe the maintainer can take
> a look whether there's a nice way to get rid of that one?
> 
I know and we have it on our schedule, 
but it's not as easy as it might look like .
