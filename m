Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYBTFsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYBTFsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYBTFsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:48:12 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39692 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106AbYBTFsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:48:10 -0500
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: Re: [PATCH 0/2] cgroup map files: Add a key/value map file type to
 cgroups
In-Reply-To: Your message of "Tue, 19 Feb 2008 21:15:44 -0800"
	<20080220051544.018684000@menage.corp.google.com>
References: <20080220051544.018684000@menage.corp.google.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080220054809.86BFC1E3C58@siro.lan>
Date: Wed, 20 Feb 2008 14:48:09 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These patches add a new cgroup control file output type - a map from
> strings to u64 values - and make use of it for the memory controller
> "stat" file.
> 
> It is intended for use when the subsystem wants to return a collection
> of values that are related in some way, for which a separate control
> file for each value would make the reporting unwieldy.
> 
> The advantages of this are:
> 
> - more standardized output from control files that report
> similarly-structured data
> 
> - less boilerplate required in cgroup subsystems
> 
> - simplifies transition to a future efficient cgroups binary API
> 
> Signed-off-by: Paul Menage <menage@google.com>

it changes the format from "%s %lld" to "%s: %llu", right?
why?

YAMAMOTO Takashi
