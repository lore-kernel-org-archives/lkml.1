Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYLKRGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYLKRGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYLKRFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:05:53 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7919 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYLKRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:05:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=m3VvzCk5iA+lUdyb+xsMxwZIOuxOtHvn4Chz4H+xC/eJzdjSC7OnULxuP3eZXL1gR
	SpA84GOSAexB1HB7SIHUw==
MIME-Version: 1.0
In-Reply-To: <20081211155323.957eb73c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081210233654.563182000@menage.corp.google.com>
	 <20081210234432.236302000@menage.corp.google.com>
	 <20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com>
	 <20081211100501.bf538f0c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081211063307.GL3008@balbir.in.ibm.com>
	 <20081211155323.957eb73c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 11 Dec 2008 09:05:47 -0800
Message-ID: <6599ad830812110905k4e32363fp671bf88e18fbf349@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory 
	controller
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 10:53 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Could you write a document to explain what kind of nest of locks are allowed
> before merging this ?

We should probably treat it similarly to the cpuset "callback_mutex".
I.e. memory allocations are most likely forbidden when you're holding
it.

Paul
