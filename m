Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZGXUba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZGXUba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZGXUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:31:28 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27406 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZGXUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:31:26 -0400
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, agk@redhat.com,
       snitzer@redhat.com, nicholas.dokos@hp.com
From: Nick Dokos <nicholas.dokos@hp.com>
Reply-To: nicholas.dokos@hp.com
Subject: Re: Regression in 2.6.31-rc3 (and presumably 2.6.31-rc4?) 
In-Reply-To: Message from "Alan D. Brunelle" <Alan.Brunelle@hp.com> 
   of "Fri, 24 Jul 2009 16:24:15 EDT." <1248467055.7964.12.camel@cail> 
References: <1248467055.7964.12.camel@cail> 
X-Mailer: MH-E 8.2; nmh 1.2; GNU Emacs 23.1.50
Date: Fri, 24 Jul 2009 16:31:58 -0400
Message-ID: <8899.1248467518@alphaville.usa.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:

> I did a diffstat between 2.6.31-rc3 and -rc4 and didn't see anything in
> the MD space, so...
> 
> I am unable to create multi-disk LVM striped-volumes with this commit in
> place - Nick Dokos @ HP did the bisecting and found that removing this
> commit fixes the same problem for him:
> 
> 754c5fc7ebb417b23601a6222a6005cc2e7f2913 is first bad commit
> commit 754c5fc7ebb417b23601a6222a6005cc2e7f2913
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Mon Jun 22 10:12:34 2009 +0100
> 
>     dm: calculate queue limits during resume not load
> 

I pulled from agk's tree after seeing his pull request and applied
commit 5dea271b6d87bd1d79a59c1d5baac2596a841c37 (plus two more) on
top of 2.6.41-rc4: I don't see the problem any longer.

Thanks,
Nick

