Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZANIqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZANIqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZANIqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:46:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbZANIqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:46:38 -0500
Message-ID: <496DA63A.8010404@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 16:45:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix return value of mem_cgroup_hierarchy_write()
References: <496D9E0C.4060806@cn.fujitsu.com> <20090114083835.GL27129@balbir.in.ibm.com>
In-Reply-To: <20090114083835.GL27129@balbir.in.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Li Zefan <lizf@cn.fujitsu.com> [2009-01-14 16:10:52]:
> 
>> When there are sub-dirs, writing to memory.use_hierarchy returns -EBUSY,
>> this doesn't seem to fit the meaning of EBUSY, and is inconsistent with
>> memory.swappiness, which returns -EINVAL in this case.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> The patch does much more than the changelog says. The reason for EBUSY
> is that the group is in use due to children or existing references and
> tasks. I think EBUSY is the correct error code to return.
> 

Sounds reasonable for me. Thanks.

Regards
Li Zefan
