Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYKDGX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYKDGX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKDGXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:23:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:33832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYKDGXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:23:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=EOBkjet1vN+NVm+ubuTkQdWFgJEIbEUto5paD9LfJ5MppU2x1dlXs/bCeVjcztIiI
	5xQvjxY+XD5/jPP9+JIJA==
MIME-Version: 1.0
In-Reply-To: <20081104151748.4731f5a1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081031115057.6da3dafd.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081031115241.1399d605.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830811032215j3ce5dcc1g6d0c3e9439a004d@mail.gmail.com>
	 <20081104151748.4731f5a1.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 3 Nov 2008 22:23:11 -0800
Message-ID: <6599ad830811032223r4c655c2dsc0c4b61c048039f9@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/5] memcg : force_empty to do move account
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, taka@valinux.co.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 10:17 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >
>> >        mem = memcg;
>> > -       ret = mem_cgroup_try_charge(mm, gfp_mask, &mem);
>> > +       ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
>>
>> Isn't this the same as the definition of mem_cgroup_try_charge()? So
>> you could leave it as-is?
>>
> try_charge is called by other places....swapin.
>

No, I mean here you can call mem_cgroup_try_charge(...) rather than
__mem_cgroup_try_charge(..., true).

Paul
