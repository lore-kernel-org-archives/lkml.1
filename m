Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYKSHyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYKSHyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYKSHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:54:30 -0500
Received: from smtp2.sms.unimo.it ([155.185.44.12]:53425 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbYKSHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:54:29 -0500
X-Greylist: delayed 2684 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 02:54:29 EST
Message-ID: <4923BBA2.1070609@unimore.it>
Date: Wed, 19 Nov 2008 08:09:22 +0100
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nauman Rafique <nauman@google.com>
CC: Fabio Checconi <fchecconi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Vivek Goyal <vgoyal@redhat.com>, Divyesh Shah <dpshah@google.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
References: <20081113.180558.519459540419535699.ryov@valinux.co.jp>	 <af41c7c40811131041t1b8491b6la5574ebe75f89000@mail.gmail.com>	 <20081113214642.GG7542@redhat.com>	 <af41c7c40811131457w472e4a86tb5344cc1d3d366fb@mail.gmail.com>	 <20081114160525.GE24624@redhat.com>	 <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com>	 <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com>	 <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com>	 <20081118120508.GD15268@gandalf.sssup.it> <e98e18940811181433o4bb5a147i1e0b9c1baf495ae2@mail.gmail.com>
In-Reply-To: <e98e18940811181433o4bb5a147i1e0b9c1baf495ae2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nauman Rafique ha scritto:
>
>
> I think "time only budget" vs "sector budget" is dependent on the
> definition of fairness: do you want to be fair in the time that is
> given to each cgroup or fair in total number of sectors transferred.
> And the appropriate definition of fairness depends on how/where the IO
> scheduler is used. ...
>
>   
Just a general note: as Fabio already said, switching back to time 
budgets in BFQ would be (conceptually) straightforward.
However, we will never get fairness in bandwidth distribution if we work 
(only) in the time domain.



-- 
-----------------------------------------------------------
| Paolo Valente              |                            |
| Algogroup                  |                            |
| Dip. Ing. Informazione     | tel:   +39 059 2056318     |
| Via Vignolese 905/b	     | fax:   +39 059 2056199     |
| 41100 Modena               | 				  |
|     home:  http://algo.ing.unimo.it/people/paolo/       |
-----------------------------------------------------------

