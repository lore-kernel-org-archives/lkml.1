Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZGGR2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZGGR2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZGGR2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:28:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43911 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbZGGR2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:28:42 -0400
Message-ID: <4A5385AD.9000800@redhat.com>
Date: Tue, 07 Jul 2009 13:28:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <482d25af-01eb-4c2a-9b1d-bdaf4020ce88@default>
In-Reply-To: <482d25af-01eb-4c2a-9b1d-bdaf4020ce88@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:

> "Preswap" IS persistent, but for various reasons may not always be
> available for use, again due to factors that may not be visible to the
> kernel (but, briefly, if the kernel is being "good" and has shared its
> resources nicely, then it will be able to use preswap, else it will not).
> Once a page is put, a get on the page will always succeed. 

What happens when all of the free memory on a system
has been consumed by preswap by a few guests?

Will the system be unable to start another guest,
or is there some way to free the preswap memory?

