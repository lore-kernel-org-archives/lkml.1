Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYFEVwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYFEVwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYFEVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:52:39 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:54127 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYFEVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:52:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao1vAOX8R0jVchRXPGdsb2JhbACBVYcOiRYBAQEBLQEknk8
Message-ID: <41480.192.168.101.12.1212702756.squirrel@intranet>
In-Reply-To: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Thu, 5 Jun 2008 23:52:36 +0200 (CEST)
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for 
     prevent fork bomb by cgroup)
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: containers@lists.osdl.org, "LKML" <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Paul Menage" <menage@google.com>
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
>
> I create new cgroup of number task restriction.
> Please any comments!

Would it make more sense to implement this as part of an rlimit subsystem,
which also supports limiting e.g. address space, CPU time, number of open
files, etc.? If we create one subsystem per resource, I'm afraid we're
going to see quite some time spent in all those loops, and the options for
cgroupfs is going to become pretty long if you want to exclude just one or
two of the subsystems for one particular mount point.

-- 
Daniel Hokka Zakrisson
