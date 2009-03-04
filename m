Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZCDB7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZCDB7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbZCDB7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:59:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZCDB67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:58:59 -0500
Message-ID: <49ADE099.1090009@cn.fujitsu.com>
Date: Wed, 04 Mar 2009 09:59:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroups: show correct file mode, fix
References: <49ACC037.2090507@cn.fujitsu.com>	<20090303122733.af5ceea9.akpm@linux-foundation.org>	<49ADDEF9.7020308@cn.fujitsu.com> <20090304105403.23352011.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090304105403.23352011.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 04 Mar 2009 09:52:57 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> - 'mode' should have type mode_t
>> - use S_IRUGO/S_IWUSR instead of 0444/0200
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thank you for quick work. I'll write memcg part on this.
> 

Ah, you don't need to do so. All the files in memcg will show their
correct file mode, which is what this patch does.


