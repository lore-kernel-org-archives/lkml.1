Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZCLLXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZCLLXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZCLLXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:23:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:37676 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZCLLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RPIYHJz5IvFhruGbx5595QxiG7lQTKwKysfuZUOAJ1x74FXD0QAed4+rVs8owCmbdM
         v1FrXyxiOkjzM2+4MGBZ00c8wjo9qLNsGL4M67IjIPD8lqsjPKVjf0rrartODiGjfcb3
         irrupQ4zDTLyQee1McpJvymtnyaViTj3eoq/0=
MIME-Version: 1.0
In-Reply-To: <20090312094529.GA4335@balbir.in.ibm.com>
References: <20090312041414.GG23583@balbir.in.ibm.com>
	 <20090312131739.296785da.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090312164204.43B7.A69D9226@jp.fujitsu.com>
	 <20090312094529.GA4335@balbir.in.ibm.com>
Date: Thu, 12 Mar 2009 20:23:39 +0900
X-Google-Sender-Auth: f9d144a92d0d8235
Message-ID: <2f11576a0903120423i56958bbbuc88cdd8cec5c9c17@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH 1/5] memcg use correct scan number at reclaim
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > IIUC, # of pages to be scanned is just determined once, here.
>>
>> In this case, lockless is right behavior.
>> lockless is valuable than precise ZSTAT. end user can't observe this race.
>>
>
> Lockless works fine provided the data is correctly aligned. I need to
> check this out more thoroghly.

Thanks a lot :)
