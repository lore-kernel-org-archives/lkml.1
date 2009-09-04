Return-Path: <linux-kernel-owner+w=401wt.eu-S934475AbZIDXbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbZIDXbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 19:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbZIDXa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 19:30:59 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46301 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408AbZIDXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 19:30:58 -0400
Date: Fri, 4 Sep 2009 16:30:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Message-Id: <20090904163044.9a883426.randy.dunlap@oracle.com>
In-Reply-To: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt014.oracle.com [141.146.116.23]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AA1A326.01C0:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Sep 2009 16:40:06 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-09-03-16-35 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


fs/proc/kcore.c:227: error: implicit declaration of function 'get_sparsemem_vmemmap_info'


patch:
in fs/proc/kcore.c, line 189, spell the function name correctly:
s/get_sparsemem_vmemamp_info/get_sparsemem_vmemmap_info/



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
