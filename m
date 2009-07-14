Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbZGNAUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbZGNAUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZGNAUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:20:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZGNAUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:20:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hMbdnqb+5wY+l0SvGAEq8nJuEQUBWhTrdBmhph03WNafvnT6dzODyLE3SsG0thlVB
	4QR8D0n/49RBvIsEnv+9g==
MIME-Version: 1.0
In-Reply-To: <1247530581-31416-1-git-send-email-vbuzov@embeddedalley.com>
References: <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
	 <1247530581-31416-1-git-send-email-vbuzov@embeddedalley.com>
Date: Mon, 13 Jul 2009 17:20:08 -0700
Message-ID: <6599ad830907131720j4f7e1649y4866d2ddeae862c5@mail.gmail.com>
Subject: Re: [PATCH 0/2] Memory usage limit notification feature (v3)
From: Paul Menage <menage@google.com>
To: Vladislav Buzov <vbuzov@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Linux memory management list <linux-mm@kvack.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 5:16 PM, Vladislav
Buzov<vbuzov@embeddedalley.com> wrote:
>
> The following sequence of patches introduce memory usage limit notification
> capability to the Memory Controller cgroup.
>
> This is v3 of the implementation. The major difference between previous
> version is it is based on the the Resource Counter extension to notify the
> Resource Controller when the resource usage achieves or exceeds a configurable
> threshold.
>
> TODOs:
>
> 1. Another, more generic notification mechanism supporting different  events
>   is preferred to use, rather than creating a dedicated file in the Memory
>   Controller cgroup.

I think that defining the the more generic userspace-API portion of
this TODO should come *prior* to the new feature in this patch, even
if the kernel implementation isn't initially generic.

Paul
