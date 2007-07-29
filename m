Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbXG2REZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbXG2REZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764046AbXG2RES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:04:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48362 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762774AbXG2RER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:04:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qX0dDPG/WY0+lROligIEPin8bf/fgba3rusNUaT3z5HAOXeOCw2cj5gEzgnsLib13
	eaa45CQ0zJPwGkwSoQtqw==
Message-ID: <6599ad830707291003s38ccc07ds79b8d0e94469871d@mail.gmail.com>
Date: Sun, 29 Jul 2007 10:03:49 -0700
From: "Paul Menage" <menage@google.com>
To: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH 01/10] Task Containers(V11): Basic task container framework
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, rohitseth@google.com
In-Reply-To: <20070727053120.2EFAC1BF6B8@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720191247.388947000@menage.corp.google.com>
	 <20070727053120.2EFAC1BF6B8@siro.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
> > +Other fields in the container_subsys object include:
>
> > +- hierarchy: an index indicating which hierarchy, if any, this
> > +  subsystem is currently attached to. If this is -1, then the
> > +  subsystem is not attached to any hierarchy, and all tasks should be
> > +  considered to be members of the subsystem's top_container. It should
> > +  be initialized to -1.
>
> stale info?

Yes, I think so. I really need to do a proper pass over
Documentation/containers.txt one more time following a bunch of recent
changes.

>
> > +struct container {
>
> > +     struct containerfs_root *root;
> > +     struct container *top_container;
> > +};
>
> can cont->top_container be different from than &cont->root.top_container?

No, I guess it can't. And there are only a couple of places using
cont->top_container now, so I should probably remove it.

Thanks,

Paul
