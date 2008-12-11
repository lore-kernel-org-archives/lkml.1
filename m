Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYLKBK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYLKBK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYLKBKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:10:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49523 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLKBKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:10:48 -0500
Date: Thu, 11 Dec 2008 10:09:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
Message-Id: <20081211100953.74d4c026.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830812101628o3899c091gd39ef9bd5df851b0@mail.gmail.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	<29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
	<6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
	<20081211092531.175c6830.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812101628o3899c091gd39ef9bd5df851b0@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 16:28:38 -0800
Paul Menage <menage@google.com> wrote:

> On Wed, Dec 10, 2008 at 4:25 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >>
> >> Can you clarify what you mean by "rolling update of refcnts"?
> >>
> >  for(..i++)
> >        atomic_dec/inc( refcnt[i)
> >
> > But my first version of this patch did above. I can write it again easily.
> 
> I just sent out a small patch collection that had my version of
> css_tryget() in it - is that what you had in mind by "rolling update"?
> 
yes. but yours seems to be more robust than my version.
I'll try to use yours and prepare a patch for css_tryget() in memcg.
 
-Kame

