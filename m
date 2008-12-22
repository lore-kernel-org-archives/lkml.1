Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYLVTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYLVTOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYLVTOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:14:37 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:39411 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLVTOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:14:36 -0500
Date: Mon, 22 Dec 2008 11:14:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Edward Estabrook" <edward.estabrook.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>, hjk@linutronix.de,
       edward_estabrook@agilent.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Documentatin for userspace DMA
 support
Message-Id: <20081222111402.4e6f2b96.randy.dunlap@oracle.com>
In-Reply-To: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
References: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.494FE6FE.02EE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 20:53:27 -0800 Edward Estabrook wrote:

> --- linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl.orig	2008-12-03
> 12:03:43.000000000 -0800
> +++ linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl	2008-12-03
> 13:11:53.000000000 -0800
> @@ -572,6 +602,50 @@ to set up sysfs files for this mapping.
>  	</para>
>  </sect1>
> 
> +<sect1 id="dma_region_mmap">
> +<title>Allocating DMA region with mmap()</title>

          Allocating a DMA region with mmap()

> +	<para>
> +	To allocate and map a DMA memory region you use

duplicate "use use".  Instead of dropping the second one, make it "the".

> +	use <function>mmap()</function>.  You may create as
> +	many regions as system resources allow by repeated use of
> +	<function>mmap()</function>.
> +	</para>


---
~Randy
