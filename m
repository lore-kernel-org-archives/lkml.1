Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbYE3KFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbYE3KFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYE3KEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:04:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40784 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753507AbYE3KEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:04:41 -0400
Date: Fri, 30 May 2008 10:50:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: miaox@cn.fujitsu.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/3] cpusets: cleanup kernel-doc
Message-ID: <20080530105018.71dac558@core>
In-Reply-To: <483FAD74.5040702@cn.fujitsu.com>
References: <483FAD74.5040702@cn.fujitsu.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 15:32:04 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> 1. Use '/*' instead of '/**' for static functions.
> 2. Remove redundant blank line.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

NAK. These are not redundant, they are used to pull documentation out of
the tree using kernel-doc or other tools that know how to finish entries
out for both inline and non-inlines.

Alan
