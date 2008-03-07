Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYCGIma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYCGIma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbYCGIlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:41:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:3234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbYCGIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:41:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=chULQEL/gdM0DHevO2SLBhPC5YalTvzys2Dk4sdjwVNTeUKT/4qA/kfnV6xqhRMda
	NbGd1WHgsSWgaJyoj/XBQ==
Message-ID: <6599ad830803070040i5e54f5f3u9b4c753ac5a87771@mail.gmail.com>
Date: Fri, 7 Mar 2008 00:40:58 -0800
From: "Paul Menage" <menage@google.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.00.0803062111560.26462@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>
	 <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com>
	 <47D0C76D.8050207@linux.vnet.ibm.com>
	 <alpine.DEB.1.00.0803062111560.26462@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 9:14 PM, David Rientjes <rientjes@google.com> wrote:
>
>  Since the command line is logically delimited by spaces, you can
>  accidently disable a subsystem if its name appears in any of your kernel
>  options following your cgroup_disable= option.

I think that you're confusing this with things like the very early
memory init setup parameters, which do operate on the raw commandline.

By the time anything is passed to a __setup() function, it's already
been split into separate strings at space boundaries.

Paul
