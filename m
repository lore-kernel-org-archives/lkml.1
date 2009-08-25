Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZHYLqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZHYLqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZHYLqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:46:07 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:54668 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZHYLqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZPOtf0zl6N3yjKZDe3NKueRBew5nCr2dcHczxDyjssL0Q47KuBqnpZ/QFwqvx/nwh2
         HM2JyNM8+3jvNGJO6JxleoEiadaBY7Ukg1OUAEZNXqfmOBHlP4lp4uphKbOJfV76Eau6
         09XMduT+HN/QYUNATZ5+rMnhGLBbIkcfxn73E=
MIME-Version: 1.0
In-Reply-To: <20090825183734.1b2d0559.kamezawa.hiroyu@jp.fujitsu.com>
References: <82e12e5f0908220954p7019fb3dg15f9b99bb7e55a8c@mail.gmail.com>
	 <28c262360908231844o3df95b14v15b2d4424465f033@mail.gmail.com>
	 <20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0908232113w71676aatf22eb6d431501fd0@mail.gmail.com>
	 <82e12e5f0908242146uad0f314hcbb02fcc999a1d32@mail.gmail.com>
	 <Pine.LNX.4.64.0908250947400.2872@sister.anvils>
	 <20090825183734.1b2d0559.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 25 Aug 2009 20:46:07 +0900
Message-ID: <28c262360908250446g5ab88437oab0eec4b1fb7df53@mail.gmail.com>
Subject: Re: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 6:37 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 25 Aug 2009 10:03:30 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
>> My advice (but I sure hate giving advice before I've tried it myself)
>> is to put __mlock_vma_pages_range() back to handling just the mlock
>> case, and do your own follow_page() loop in munlock_vma_pages_range().
>>
>
> I have no objections to make use of follow_page().

Me, too.
We don't need to add new flag although there is simple method like this.

> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
