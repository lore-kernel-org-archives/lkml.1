Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYGEGTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYGEGTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYGEGSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:18:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42272 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYGEGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:18:54 -0400
Date: Sat, 05 Jul 2008 15:14:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] Make CONFIG_MIGRATION available for s390
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080705130203.e7df168c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1215183539.4834.12.camel@localhost.localdomain> <20080705130203.e7df168c.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080705150659.024F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >  config MIGRATION
> >  	bool "Page migration"
> >  	def_bool y
> > -	depends on NUMA
> > +	depends on NUMA || S390

Hmm. I think ARCH_ENABLE_MEMORY_HOTREMOVE is better than S390.

Bye.


-- 
Yasunori Goto 


