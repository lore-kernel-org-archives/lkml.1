Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYDKExs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYDKExs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYDKExk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:53:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56273 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYDKExj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:53:39 -0400
Date: Fri, 11 Apr 2008 13:58:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v9)
Message-Id: <20080411135810.87536503.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47FEED67.1080006@linux.vnet.ibm.com>
References: <20080410091602.4472.32172.sendpatchset@localhost.localdomain>
	<20080411123339.89aea319.kamezawa.hiroyu@jp.fujitsu.com>
	<47FEE89A.1010102@linux.vnet.ibm.com>
	<20080411134739.1aae8bae.kamezawa.hiroyu@jp.fujitsu.com>
	<47FEED67.1080006@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 10:17:35 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Good question. It is possible that clone() was called with CLONE_VM without
> CLONE_THREAD. In which case we have threads sharing the VM without a thread
> group leader. Please see zap_threads() for a similar search pattern.
> 
Oh. thank you for kindly explanation.

I'll test this on 2.6.25-rc8-mm2.

Regards,
-Kame

