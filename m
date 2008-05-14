Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYENTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYENTnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbYENTm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:42:56 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38104 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYENTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:40:12 -0400
Date: Thu, 15 May 2008 01:09:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and
	control (v4)
Message-ID: <20080514193946.GA31115@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Pavel Emelyanov <xemul@openvz.org>, linux-mm@kvack.org,
	Sudhir Kumar <skumar@linux.vnet.ibm.com>,
	YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
	Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130951.24440.73671.sendpatchset@localhost.localdomain> <482AE9FA.4080004@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <482AE9FA.4080004@openvz.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Emelyanov <xemul@openvz.org> [2008-05-14 17:32:42]:

> 
> AFAIS you didn't cover all the cases when VM expands. At least all
> the arch/ia64/ia32/binfmt_elf32.c is missed.
> 
> I'd insert this charge into insert_vm_struct. This would a) cover
> all of the missed cases and b) reduce the amount of places to patch.
>

I thought I have those covered. insert_vm_struct() is called from
places that we have covered in this patch. As far as
arch/ia64/ia32/binfmt_elf32.c is concerned, it inserts a GDT, LDT
and does not change total_vm. Having said that, I am not against
putting the hooks in insert_vm_struct().
 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
