Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXFFNV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXFFNV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760222AbXFFNVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:21:50 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:41055 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958AbXFFNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:21:50 -0400
Date: Wed, 6 Jun 2007 09:21:47 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Eric Paris <eparis@redhat.com>
cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       chrisw@redhat.com, sds@tycho.nsa.gov, sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
In-Reply-To: <1181111433.3978.48.camel@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0706060919560.28120@d.namei>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> 
 <20070603205653.GE25869@devserv.devel.redhat.com> 
 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> 
 <1181075666.3978.31.camel@localhost.localdomain>  <Line.LNX.4.64.0706051658170.23379@d.namei>
  <20070605211616.GE23291@devserv.devel.redhat.com>
 <1181111433.3978.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Eric Paris wrote:

> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "mmap_min_addr",
> +		.data		= &mmap_min_addr,
> +		.maxlen         = sizeof(unsigned long),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,

proc_doulongvec_minmax

(I can fix this in my tree rather than a resend just for this, if
there are some acks & no other problems).


-- 
James Morris
<jmorris@namei.org>
