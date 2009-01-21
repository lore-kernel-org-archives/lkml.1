Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbZAUKq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbZAUKq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbZAUKqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:46:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59854 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbZAUKqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:46:19 -0500
Date: Wed, 21 Jan 2009 19:45:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 4/4] cgroup-memcg fix frequent EBUSY at rmdir v2
Message-Id: <20090121194509.b5084225.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901210243k433f618bva4ec756b769be4d4@mail.gmail.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
	<20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901131905ie10e4bl5168ab7f337b27e1@mail.gmail.com>
	<20090114121205.1bb913aa.kamezawa.hiroyu@jp.fujitsu.com>
	<20090120194735.cc52c5e0.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901210200q77b2553ag35f706c321a18d83@mail.gmail.com>
	<20090121193248.94aecb10.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901210243k433f618bva4ec756b769be4d4@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 02:43:44 -0800
Paul Menage <menage@google.com> wrote:

> On Wed, Jan 21, 2009 at 2:32 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Hmm, subsystem may return -EPERM or some..
> > I'll change this to
> >
> >  if (!ret)
> >    return ret;
> 
> You mean
> 
> if (ret)
>   return ret;
> 
Yes. (>_<!

-Kame

