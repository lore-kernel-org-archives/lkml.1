Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZAGRZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZAGRZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZAGRZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:25:34 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37646 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZAGRZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:25:33 -0500
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <200901071828.13719.chandru@in.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
	 <200901051919.52327.chandru@in.ibm.com> <1231173033.19452.190.camel@nimitz>
	 <200901071828.13719.chandru@in.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 09:25:25 -0800
Message-Id: <1231349125.23462.81.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 18:28 +0530, Chandru wrote:
> I don't know how you wanted NODE_DATA() to be consulted here. i.e before 
> calling reserve_bootmem_node() should we have a condition 
> 
>         if (PFN_UP(physbase+reserve_size) > node_end_pfn) 
>         then
>                 resize reserve_size again so that PFN_UP() will equate to node_end_pfn ??
>         end 

I'm just suggesting making your fix in the ppc code instead of in
mm/bootmem.c.

-- Dave

