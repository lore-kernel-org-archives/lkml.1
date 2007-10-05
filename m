Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbXJETRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbXJETRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbXJETRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:17:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54039 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759232AbXJETRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:17:42 -0400
Date: Fri, 5 Oct 2007 12:17:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-mm@kvack.org
Subject: Re: [Patch]Documentation/vm/slabinfo.c: clean up this code
In-Reply-To: <20071005124614.GD12498@hacking>
Message-ID: <Pine.LNX.4.64.0710051216250.17345@schroedinger.engr.sgi.com>
References: <20071005124614.GD12498@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, WANG Cong wrote:

> 
> This patch does the following cleanups for Documentation/vm/slabinfo.c:
> 
> 	- Fix two memory leaks;

For user space code? Memory will be released as soon as the program 
terminates.

> 	- Constify some char pointers;
> 	- Use snprintf instead of sprintf in case of buffer overflow;
> 	- Fix some indentations;
> 	- Other little improvements.

Acked-by: Christoph Lameter <clameter@sgi.com>

