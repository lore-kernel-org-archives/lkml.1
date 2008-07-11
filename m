Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbYGKNGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbYGKNGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYGKNGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:06:40 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:27061 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYGKNGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:06:40 -0400
Subject: Re: [PATCH] Make CONFIG_MIGRATION available w/o NUMA
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <48736D0F.5080208@linux-foundation.org>
References: <1215354957.9842.19.camel@localhost.localdomain>
	 <4872319B.9040809@linux-foundation.org>
	 <1215451689.8431.80.camel@localhost.localdomain>
	 <48725480.1060808@linux-foundation.org>
	 <1215455148.8431.108.camel@localhost.localdomain>
	 <48726158.9010308@linux-foundation.org>
	 <1215514245.4832.7.camel@localhost.localdomain>
	 <48736D0F.5080208@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 11 Jul 2008 15:05:50 +0200
Message-Id: <1215781550.4746.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-08 at 08:35 -0500, Christoph Lameter wrote:
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Small nit: It now looks as if the vma_migratable() function belongs into mempolicy.h and not migrate.h

Right, I'll send a new patch that moves vma_migratable() to mempolicy.h

Thanks,
Gerald


