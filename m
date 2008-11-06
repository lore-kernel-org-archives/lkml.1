Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYKFOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYKFOay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYKFOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:30:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44839 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKFOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:30:32 -0500
Message-ID: <6941.10.75.179.62.1225981828.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <4912F53A.2070407@linux.vnet.ibm.com>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
    <49129493.9070103@linux.vnet.ibm.com>
    <20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
    <4912F53A.2070407@linux.vnet.ibm.com>
Date: Thu, 6 Nov 2008 23:30:28 +0900 (JST)
Subject: Re: [RFC][PATCH 7/6] memcg: add atribute (for change bahavior 
     ofrmdir)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
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

Balbir Singh said:
> KAMEZAWA Hiroyuki wrote:
>> BTW, cost of movement itself is not far from cost for force_empty.
>>
>> If you can't find why "forget" is bad, please consider one more day.
>
> The attributes seem quite reasonable, I've taken a quick look, not done a
> full
> review or test.
>
Thanks, I'll go ahead in this direction.

By the way, should we keep "one value per one file" for attributes ?
If so, I'll add a new file just for this.
Current my patch allows prural attributes set on a file.

Thanks,
-Kame

