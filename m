Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbZAUKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbZAUKo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbZAUKnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:43:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbZAUKnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:43:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=eaIsLuPi7+rYkvhbuRzYFsdIU8bLC3TDlkeBpIMvTcWeXjxjbQhZ0ppf1f/jxCYxl
	e0LzWfep0rSkWG+tmttXA==
MIME-Version: 1.0
In-Reply-To: <20090121193248.94aecb10.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
	 <20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901131905ie10e4bl5168ab7f337b27e1@mail.gmail.com>
	 <20090114121205.1bb913aa.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090120194735.cc52c5e0.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901210200q77b2553ag35f706c321a18d83@mail.gmail.com>
	 <20090121193248.94aecb10.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 21 Jan 2009 02:43:44 -0800
Message-ID: <6599ad830901210243k433f618bva4ec756b769be4d4@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/4] cgroup-memcg fix frequent EBUSY at rmdir v2
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 2:32 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hmm, subsystem may return -EPERM or some..
> I'll change this to
>
>  if (!ret)
>    return ret;

You mean

if (ret)
  return ret;

Paul
