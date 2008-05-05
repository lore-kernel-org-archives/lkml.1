Return-Path: <linux-kernel-owner+w=401wt.eu-S1763143AbYEEWks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763143AbYEEWks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760513AbYEEWj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:39:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54570 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbYEEWjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:39:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=rjJ0nDkDVZocik1J3URzezppXey4zAufk1APdTE3y2cUkT/qmyWzwnyId3uyIkGjt
	V6ct9+z3Bdzf8dtSzzK0Q==
Date: Mon, 5 May 2008 15:32:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp, menage@google.com,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 3/4] Add rlimit controller accounting and control
In-Reply-To: <20080505152451.6dceec74.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0805051530590.15653@chino.kir.corp.google.com>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213814.3140.66080.sendpatchset@localhost.localdomain> <20080505152451.6dceec74.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Andrew Morton wrote:

> IOW, have we chosen the best, most maintainable representation for these
> things?
> 

There was discussion early on in the development of the memory controller 
that bytes were going to be used as the base unit for accounting.  I had 
disagreed in favor of kB since page sizes are always in these increments 
and historically the kernel has exported statistics this way via 
/proc/meminfo.
