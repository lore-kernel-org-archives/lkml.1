Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbXFVQXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbXFVQXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXFVQXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:23:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60945 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758043AbXFVQW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:22:59 -0400
Date: Fri, 22 Jun 2007 09:22:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Cedric Le Goater <clg@fr.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
In-Reply-To: <467B7EB6.4050207@fr.ibm.com>
Message-ID: <Pine.LNX.4.64.0706220920190.16635@schroedinger.engr.sgi.com>
References: <4676F0B9.3080408@fr.ibm.com> <20070619113501.a88bba50.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706191222420.7008@schroedinger.engr.sgi.com>
 <467B7EB6.4050207@fr.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Cedric Le Goater wrote:

> the macro sets the align parameter to "__alignof__(struct)" by default. 
> is that something we want to do all the time ? if so, why not change 
> kmem_cache_create() directly ?

Its a safety net. If there is some reason that the structure needs a 
larger alignment than ARCH_KMALLOC_MINALIGN then that alignment will be 
applied.
 
> Most of the complexity is in flags. I did a grep and picked what i thought 
> was the most aggressive. The macro would probably be more useful if we could 
> identify by it's name in which context it can be used. 

What context are you thinking about and how would it influence 
the macro?

