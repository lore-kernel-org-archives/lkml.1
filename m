Return-Path: <linux-kernel-owner+w=401wt.eu-S935241AbYBWISY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241AbYBWISY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764414AbYBWIJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:24 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762127AbYBWIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:05 -0500
Date: Sat, 23 Feb 2008 00:04:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: Re: [PATCH 0/2] cgroup map files: Add a key/value map file type to
 cgroups
Message-Id: <20080223000413.4b10db88.akpm@linux-foundation.org>
In-Reply-To: <20080221212854.408662000@menage.corp.google.com>
References: <20080221212854.408662000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 13:28:54 -0800 menage@google.com wrote:

> These patches add a new cgroup control file output type - a map from
> strings to u64 values - and make use of it for the memory controller
> "stat" file.

Can we document the moderately obscure kernel->userspace interface
somewhere please?
