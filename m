Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbYDHBEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbYDHBEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 21:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYDHBEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 21:04:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60358 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYDHBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 21:04:15 -0400
Date: Tue, 8 Apr 2008 10:09:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pavel Emelianov <xemul@openvz.org>,
       hugh@veritas.com
Subject: Re: [-mm] Disable the memory controller by default (v2)
Message-Id: <20080408100902.fcd9d911.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080407130215.26565.81715.sendpatchset@localhost.localdomain>
References: <20080407130215.26565.81715.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Apr 2008 18:32:15 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Changelog v1
> 
> 1. Split cgroup_disable into cgroup_disable and cgroup_enable
> 2. Remove cgroup_toggle
> 
> Due to the overhead of the memory controller. The
> memory controller is now disabled by default. This patch adds cgroup_enable.
> 
> If everyone agrees on this approach and likes it, should we push this
> into 2.6.25?
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
BTW, how the user can know which controllers are on/off at default ?
All controllers are off ?

Thanks,
-Kame

