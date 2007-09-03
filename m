Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXICExy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXICExy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 00:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbXICExq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 00:53:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49807 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbXICExp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 00:53:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HBpYrz24lL1ApyA/7a1HeHx99ZsgnZ91ZD6ppof3/0WNKENkIoX5Uay8Ywk/pmqcg
	+4s+EsJqchZSi8IaoPXTA==
Message-ID: <6599ad830709022153g1720bcedsb61d7cf7a783bd3f@mail.gmail.com>
Date: Sun, 2 Sep 2007 21:53:22 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm PATCH] Memory controller improve user interface (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "David Rientjes" <rientjes@google.com>,
       "Dave Hansen" <haveblue@us.ibm.com>
In-Reply-To: <20070902105021.3737.31251.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070902105021.3737.31251.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> -       s += sprintf(s, "%lu\n", *val);
> +       if (read_strategy)
> +               s += read_strategy(*val, s);
> +       else
> +               s += sprintf(s, "%lu\n", *val);

This would be better as %llu

> +               tmp = simple_strtoul(buf, &end, 10);

and this as simple_strtoull()

Paul
