Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYLDMpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYLDMpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYLDMo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:44:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35713 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYLDMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:44:55 -0500
Message-ID: <44799.10.75.179.61.1228394692.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081204200037.63ff03c9.nishimura@mxp.nes.nec.co.jp>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com><20081203141423.6f747990.kamezawa.hiroyu@jp.fujitsu.com>
    <20081204200037.63ff03c9.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 4 Dec 2008 21:44:52 +0900 (JST)
Subject: Re: [Experimental][PATCH  
     21/21]memcg-new-hierarchical-reclaim.patch
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> On Wed, 3 Dec 2008 14:14:23 +0900, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Implement hierarchy reclaim by cgroup_id.

>> +	rcu_read_lock();
>> +	if (!root_mem->use_hierarchy) {
>> +		spin_lock(&root_mem->reclaim_param_lock);
>> +		root_mem->scan_age++;
>> +		spin_unlock(&root_mem->reclaim_param_lock);
>> +		css_get(&root_mem->css);
>> +		goto out;
>>  	}
>>
> I think you forgot "ret = root_mem".
> I got NULL pointer dereference BUG in my test(I've not tested
> use_hierarchy case yet).
>
yes...thank you for catching. will fix.

-Kame

