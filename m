Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565Ab0AGAEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0AGAEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555Ab0AGAEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:04:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554Ab0AGAEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:04:24 -0500
Date: Wed, 6 Jan 2010 16:04:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-Id: <20100106160414.bd555474.akpm@linux-foundation.org>
In-Reply-To: <20091231051050.GA714@andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 00:10:50 -0500
Ben Blum <bblum@andrew.cmu.edu> wrote:

> This patch series implements support for building, loading, and
> unloading subsystems as modules, both within and outside the kernel
> source tree. It provides an interface cgroup_load_subsys() and
> cgroup_unload_subsys() which modular subsystems can use to register and
> depart during runtime. The net_cls classifier subsystem serves as the
> example for a subsystem which can be converted into a module using these
> changes.

What is the value in this?  What are the usage scenarios?  Why does the
benefit of this change exceed the cost/risk/etc of merging it?
