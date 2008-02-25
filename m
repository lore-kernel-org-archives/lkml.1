Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYBYTIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYBYTIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYBYTH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:07:59 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbYBYTH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:07:58 -0500
Date: Mon, 25 Feb 2008 10:56:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller use strstrip while parsing
 arguments
Message-Id: <20080225105606.bcab215e.akpm@linux-foundation.org>
In-Reply-To: <20080225182746.9512.21582.sendpatchset@localhost.localdomain>
References: <20080225182746.9512.21582.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 23:57:46 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> The memory controller has a requirement that while writing values, we need
> to use echo -n. This patch fixes the problem and makes the UI more consistent.

that's a decent improvement ;)

btw, could I ask that you, Paul and others who work on this and cgroups
have a think about a ./MAINTAINERS update?
