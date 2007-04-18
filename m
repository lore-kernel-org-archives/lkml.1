Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbXDRGgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbXDRGgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbXDRGgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:36:48 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48412 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXDRGgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:36:47 -0400
Message-ID: <4625BDA9.7080106@sw.ru>
Date: Wed, 18 Apr 2007 10:41:45 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eric Dumazet <dada1@cosmosbay.com>, Linux MM <linux-mm@kvack.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M (v2)
References: <4624E8F4.2090200@sw.ru> <1176831473.12599.30.camel@localhost.localdomain>
In-Reply-To: <1176831473.12599.30.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2007-04-17 at 19:34 +0400, Pavel Emelianov wrote:
>> +#define SHOW_TOP_SLABS 10 
> 
> Real minor nit on this one: SHOW_TOP_SLABS sounds like a bool.  "Should
> I show the top slabs?"
> 
> This might be a bit more clear:
> 
> #define TOP_NR_SLABS_TO_SHOW 10 
> 
> or
> 
> #define NR_SLABS_TO_SHOW 10

Agree :) Will fix in a moment.

> 
> -- Dave
> 
> 

