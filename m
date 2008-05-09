Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYEIGbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYEIGbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYEIGbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:31:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34648 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYEIGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:31:44 -0400
Date: Fri, 9 May 2008 15:25:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memory hotplug: memmap_init_zone called twice.
Message-Id: <20080509152519.1b14e016.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080509060425.GA9840@osiris.boeblingen.de.ibm.com>
References: <20080509060425.GA9840@osiris.boeblingen.de.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 08:04:25 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Subject: [PATCH] memory hotplug: memmap_init_zone called twice.
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> __add_zone calls memmap_init_zone twice if memory gets attached to
> an empty zone. Once via init_currently_empty_zone and once explictly
> right after that call.
> Looks like this is currently not a bug, however the call is
> superfluous and might lead to subtle bugs if memmap_init_zone gets
> changed. So make sure it is called only once.
> 
seems reasonable. Thank you!

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

