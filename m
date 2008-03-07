Return-Path: <linux-kernel-owner+w=401wt.eu-S1762960AbYCGJCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762960AbYCGJCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762146AbYCGJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:02:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:3945 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762106AbYCGJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:02:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=q+2cPCFIlUHAsqdYAWvnqgLVu/NpLMYe6TSvMTJVOIo1VDJx86X82Hw8baeFTayim
	7AbB0C/WReCPDhhmmJNJQ==
Date: Fri, 7 Mar 2008 00:56:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot
 time
In-Reply-To: <6599ad830803070040i5e54f5f3u9b4c753ac5a87771@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0803070055020.3470@chino.kir.corp.google.com>
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>  <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com>  <47D0C76D.8050207@linux.vnet.ibm.com>  <alpine.DEB.1.00.0803062111560.26462@chino.kir.corp.google.com>
 <6599ad830803070040i5e54f5f3u9b4c753ac5a87771@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Paul Menage wrote:

> >  Since the command line is logically delimited by spaces, you can
> >  accidently disable a subsystem if its name appears in any of your kernel
> >  options following your cgroup_disable= option.
> 
> I think that you're confusing this with things like the very early
> memory init setup parameters, which do operate on the raw commandline.
> 
> By the time anything is passed to a __setup() function, it's already
> been split into separate strings at space boundaries.
> 

Ok, so the cgroup_disable= parameter should be a list of subsystem names 
delimited by anything other than a space that the user wants disabled.  
That makes more sense, thanks.
