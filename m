Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYKDGZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYKDGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYKDGZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:25:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14899 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYKDGZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:25:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=pUHBU0Js8Ros6gkgureo2GdTlfCK0toZem8l56f0NnN+PLHOIin+cOS1i5O9d4ueh
	y04PvH6vaVG3f+rC4jQGQ==
MIME-Version: 1.0
In-Reply-To: <20081101184824.2575.5935.sendpatchset@balbir-laptop>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	 <20081101184824.2575.5935.sendpatchset@balbir-laptop>
Date: Mon, 3 Nov 2008 22:25:47 -0800
Message-ID: <6599ad830811032225w229d3a29k17b9a38cb76a521f@mail.gmail.com>
Subject: Re: [mm] [PATCH 1/4] Memory cgroup hierarchy documentation
From: Paul Menage <menage@google.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 10:48 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> +
> +The memory controller by default disables the hierarchy feature. Support
> +can be enabled by writing 1 to memory.features file of the root cgroup
> +
> +# echo 1 > memory.features
> +
> +The feature can be disabled by
> +
> +# echo 0 > memory.features

That's not a very intuitive interface. Why not memory.use_hierarchy?
(I presume that you're trying to cram multiple bits into a single
file, but that seems a bit ugly).

Paul
