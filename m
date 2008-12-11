Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYLKA2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYLKA2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYLKA2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:28:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYLKA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:28:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=uoWwrkQ+BlVoYdUs4Vet/Sdix1e4FIr/Hf3wVF8UMN8pGyO5i6yA1ILHJckZ6PiFM
	jDfaoOKpv65wYE7tT4adw==
MIME-Version: 1.0
In-Reply-To: <20081211092531.175c6830.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	 <29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
	 <6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
	 <20081211092531.175c6830.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 10 Dec 2008 16:28:38 -0800
Message-ID: <6599ad830812101628o3899c091gd39ef9bd5df851b0@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 4:25 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> Can you clarify what you mean by "rolling update of refcnts"?
>>
>  for(..i++)
>        atomic_dec/inc( refcnt[i)
>
> But my first version of this patch did above. I can write it again easily.

I just sent out a small patch collection that had my version of
css_tryget() in it - is that what you had in mind by "rolling update"?

Paul
