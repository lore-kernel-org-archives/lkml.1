Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbYDNPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbYDNPER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYDNPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:04:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbYDNPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:04:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VyxIZk70MNS1v4cglgfZI90EcyWnp1T2URjheBPnCvxXBHCASJ5cSHcpgI9VA8CDo
	bq0MdqGDfh28DfLI9aV+w==
Message-ID: <6599ad830804140803p2a97c96mbc24f73e1a687aee@mail.gmail.com>
Date: Mon, 14 Apr 2008 08:03:57 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] Control Groups Roadmap ideas
Cc: "Linux Containers" <containers@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080414141119.GA11019@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830804081414x7be75d2fte5b500a7f81df40c@mail.gmail.com>
	 <20080411144836.GA6468@sergelap.cust.hotspot.t-mobile.com>
	 <6599ad830804132224h4b958891i101c6e068ea15f55@mail.gmail.com>
	 <20080414141119.GA11019@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 7:11 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
>  then all tasks are mapped under /containers.  If login does a
>  clone(CLONE_NEWNS) for hallyn's login to give him a private /tmp,
>  then hallyn ends up under /containers/node_xyz, but we don't want him
>  to be virtualized under there.  So I assume we'd want a virt.lock file
>  or something like that so, that when I create a container, my
>  start_container script can echo 1 > /containers/node_abc/virt.lock

Yes, something like that.

>
>  I assume the container will also have to remount a fresh copy of the
>  cgroup composition so it can have the dentry for /containers/node_abc
>  as the root dentry for /containers?

Yes.

Paul
