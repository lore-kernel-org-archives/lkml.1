Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZI2RIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZI2RIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZI2RIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:08:22 -0400
Received: from broadrack.ru ([195.178.208.66]:41718 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbZI2RIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:08:21 -0400
Date: Tue, 29 Sep 2009 21:08:25 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Evgeny Polyakov <johnpol@2ka.mipt.ru>,
       Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] connector: Fix sid connector (was: Badness at kernel/softirq.c:143...)
Message-ID: <20090929170824.GB32330@ioremap.net>
References: <200909251123.03482.borntraeger@de.ibm.com> <fbbbe0a028fa.4ac1f1c0@2ka.mipt.ru> <20090929132415.GB4538@redhat.com> <200909291547.21528.borntraeger@de.ibm.com> <20090929140718.GA23858@ioremap.net> <20090929142538.GA10180@redhat.com> <20090929145413.GA26327@ioremap.net> <20090929153631.GA12699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929153631.GA12699@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 05:36:31PM +0200, Oleg Nesterov (oleg@redhat.com) wrote:
> > Doesn't it only check pgid while patch intention was to send
> > notification about sid?
> 
> If the proposed sid already was the session id, then prgp shouldn't
> be empty.
> 
> but this doesn't really matter, we also check ->signal->leader
> (not sure, but afaics this check is not strictly necessary because
>  of PIDTYPE_PGID check)

Ok, I see, thanks.

-- 
	Evgeniy Polyakov
