Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbXLNHLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbXLNHLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXLNHLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:11:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbXLNHLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:11:04 -0500
Date: Thu, 13 Dec 2007 23:09:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, rusty@rustcorp.com.au
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
Message-Id: <20071213230916.cd30de8c.akpm@linux-foundation.org>
In-Reply-To: <200712141225.30099.srinivasa@in.ibm.com>
References: <200712141225.30099.srinivasa@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 12:25:30 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> Since __init functions are discarded and its memory freed once
> initialization completes, It would be better if we enable kprobes 
> to refuse probing __init functions. The attached patchset will do 
> that.
> 
> This patch creates non_init_kernel_text_address() to identify
> non_init text area.
> 
> Iam open to suggestions for a better functionname. 
> 

It's not a great name.  One wonders how it handles __exit text, for example.

regular_kernel_text_address()?  Dunno.

