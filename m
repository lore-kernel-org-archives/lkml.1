Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbZL1CfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbZL1CfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZL1CfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:35:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54039 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbZL1CfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:35:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 11:31:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] cgroup: implement eventfd-based generic API for
 notifications
Message-Id: <20091228113154.e2c2566e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <3f29ccc3c93e2defd70fc1c4ca8c133908b70b0b.1261858972.git.kirill@shutemov.name>
References: <cover.1261858972.git.kirill@shutemov.name>
	<3f29ccc3c93e2defd70fc1c4ca8c133908b70b0b.1261858972.git.kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 04:08:59 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> This patch introduces write-only file "cgroup.event_control" in every
> cgroup.
> 
> To register new notification handler you need:
> - create an eventfd;
> - open a control file to be monitored. Callbacks register_event() and
>   unregister_event() must be defined for the control file;
> - write "<event_fd> <control_fd> <args>" to cgroup.event_control.
>   Interpretation of args is defined by control file implementation;
> 
> eventfd will be woken up by control file implementation or when the
> cgroup is removed.
> 
> To unregister notification handler just close eventfd.
> 
> If you need notification functionality for a control file you have to
> implement callbacks register_event() and unregister_event() in the
> struct cftype.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

