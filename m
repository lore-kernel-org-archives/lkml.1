Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYLKRHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYLKRHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbYLKRHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:07:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:8285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYLKRHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:07:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=JHyStwp5hg7CB7h4D5XOLax1q2DiXCyiQ3tGBm1dbk2qllKPDxRAu0RlbMhh46Jfi
	q+5SBDtgmZfnOIjTzs6QA==
MIME-Version: 1.0
In-Reply-To: <4940836A.9010502@cn.fujitsu.com>
References: <20081210233654.563182000@menage.corp.google.com>
	 <20081210234432.065445000@menage.corp.google.com>
	 <4940836A.9010502@cn.fujitsu.com>
Date: Thu, 11 Dec 2008 09:07:18 -0800
Message-ID: <6599ad830812110907r4c1bbc0dwf921609bfc117ba4@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 7:05 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> But this function is used in cgroup.c internally, and always called
> with cgroup_lock held, so it's OK to use for_each_subsys().

This is true, but it doesn't hurt to be future-proof and not require
cgroup_mutex to be held.

Paul
