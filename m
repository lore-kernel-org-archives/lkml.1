Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZGVUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZGVUX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZGVUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:23:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbZGVUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:23:28 -0400
Date: Wed, 22 Jul 2009 13:23:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [RFC 1/2] move binfmt filed to signal_struct
Message-Id: <20090722132302.a9889eb3.akpm@linux-foundation.org>
In-Reply-To: <4A56FEF7.80207@ct.jp.nec.com>
References: <4A56FEF7.80207@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 17:42:31 +0900
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Because the binfmt is not different between threads in the same process,
> it can be moved from task_struct to signal_struct.
> 

Seems like a logical cleanup to me.

We should rename signal_struct.
