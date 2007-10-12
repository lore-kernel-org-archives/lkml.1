Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbXJLQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbXJLQsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbXJLQsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:48:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:11290 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078AbXJLQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=YYBZTrhbloEf76EzFDdXcom/SyNM4E4dD+8RlC3JfUNhqv7bDgUs3EF509/X319Xo5L6kwUrjJUEuPRmlGnKBHUj0droacJP89mZvp4c159txYaBMxTpTz4E6mfhSeuSmP8wixh+OOQOIUlb6X7MEI/4Jaa2yJufGVs+C5SmVoI=
Date: Fri, 12 Oct 2007 18:42:41 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jan Blunck <jblunck@suse.de>
Cc: mingo@redhat.com, Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: kernel NULL pointer dereference in check_spread+0x0/0x26
Message-ID: <20071012164241.GB17456@slug>
References: <20071012124054.GD8471@hasse.suse.de> <20071012144644.GA17456@slug> <20071012153132.GF8471@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012153132.GF8471@hasse.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 05:31:32PM +0200, Jan Blunck wrote:
> On Fri, Oct 12, Frederik Deweerdt wrote:
> 
> > On Fri, Oct 12, 2007 at 02:40:54PM +0200, Jan Blunck wrote:
> > > This is with 2.6.23-mm1 and allmodconfig.
> > This generates a .config with CONFIG_SCHED_DEBUG=y and
> > CONFIG_FAIR_GROUP_SCHED=n (The latter causes parent_entity to return
> > NULL).
> > Does setting CONFIG_FAIR_GROUP_SCHED=y help?
> 
> No, CONFIG_FAIR_GROUP_SCHED=y was set. Or did you mean CONFIG_FAIR_CGROUP_SCHED?
He no, I misread the code, sorry for the noise.
