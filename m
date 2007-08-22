Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbXHVTS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbXHVTS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXHVTSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:18:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39522 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXHVTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:18:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Agf2pfKT+c3/yfUt7T3CM8KmBty6hrkYzWJnimlq8CVTJZ90t0V12kFCClKbvmGLU
	oycoNy9sal6txyEO5p6ew==
Message-ID: <6599ad830708221218t3c1eae51o1605f00b8f204b02@mail.gmail.com>
Date: Wed, 22 Aug 2007 12:18:03 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Memory controller Add Documentation
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Containers" <containers@lists.osdl.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070822130612.18981.58696.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822130612.18981.58696.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>
>  Documentation/memcontrol.txt |  193 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 193 insertions(+)
>
> diff -puN /dev/null Documentation/memcontrol.txt
> --- /dev/null   2007-06-01 20:42:04.000000000 +0530
> +++ linux-2.6.23-rc2-mm2-balbir/Documentation/memcontrol.txt    2007-08-22 18:29:29.000000000 +0530
> @@ -0,0 +1,193 @@
> +Memory Controller
> +
> +0. Salient features
> +
> +a. Enable control of both RSS and Page Cache pages

s/RSS/anonymous/ (and generally throughout the document)? RSS can
include pages that are part of the page cache too.

Paul
