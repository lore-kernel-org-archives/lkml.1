Return-Path: <linux-kernel-owner+w=401wt.eu-S1765831AbYBVDwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765831AbYBVDwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYBVDwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:52:00 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36487 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753083AbYBVDv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:51:59 -0500
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: Re: [PATCH 1/2] cgroup map files: Add cgroup map data type
In-Reply-To: Your message of "Thu, 21 Feb 2008 13:28:55 -0800"
	<20080221213444.898896000@menage.corp.google.com>
References: <20080221213444.898896000@menage.corp.google.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080222035158.89C4F1E3C58@siro.lan>
Date: Fri, 22 Feb 2008 12:51:58 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The map type is printed in a similar format to /proc/meminfo or
> /proc/<pid>/status, i.e. "$key: $value\n"

this description doesn't seem to match with the code.

YAMAMOTO Takashi

> +static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
> +{
> +	struct seq_file *sf = cb->state;
> +	return seq_printf(sf, "%s %llu\n", key, value);
> +}
