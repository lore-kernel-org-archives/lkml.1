Return-Path: <linux-kernel-owner+w=401wt.eu-S935998AbXGTUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935998AbXGTUlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXGTUky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:40:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14270 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbXGTUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:40:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KJfZyfk/EWF5NDo/RzJ+IAWyciS+BSBvIbB8r9ptubIwBMxeQw1X93kOjV4tN+L/s
	xMCNVFMbk0KUPB4eYFxZw==
Message-ID: <6599ad830707201333s527f20eeuc39424c7b79626@mail.gmail.com>
Date: Fri, 20 Jul 2007 13:33:48 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm PATCH 3/8] Memory controller accounting setup (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070720082429.20752.63919.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
	 <20070720082429.20752.63919.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> +       mem = mem_container_from_cont(task_container(p,
> +                                       mem_container_subsys_id));
> +       css_get(&mem->css);

The container framework won't try to free a subsystem's root container
state, so this isn't needed.

Paul
