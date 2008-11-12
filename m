Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYKLGIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYKLGIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKLGIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:08:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52596 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKLGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:08:35 -0500
Date: Wed, 12 Nov 2008 15:07:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
Message-Id: <20081112150755.b64510d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 12:26:56 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>  move_account:
> +	/* should free all ? */
> +	if (!mem->on_rmdir)
> +		goto try_to_free;
> +

This must be
==
	if (!mem->on_rmdir)
		goto try_to_free;
   move_account:
==

Sorry.
-Kame

