Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZAMVUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZAMVUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZAMVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:20:26 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37906 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZAMVUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:20:25 -0500
Subject: Re: [PATCH] ebtables match inverted in 2.6.28? (Was: Re: ebtables
	match inverted in 2.6.28?)
From: Matt Helsley <matthltc@us.ibm.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Jan Engelhardt <jengelh@medozas.de>, Matt Cross <matt.cross@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org
In-Reply-To: <496AF724.8060203@trash.net>
References: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com>
	 <1230779772.29793.31.camel@localhost> <496AD1C6.9080906@trash.net>
	 <alpine.LSU.2.00.0901120835390.21692@fbirervta.pbzchgretzou.qr>
	 <496AF724.8060203@trash.net>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 13:20:21 -0800
Message-Id: <1231881621.1117.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 08:54 +0100, Patrick McHardy wrote:
> commit c6b52c688ecf03adb82724299b97701528821ca5
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Jan 12 08:52:08 2009 +0100
> 
>     netfilter: ebtables: fix inversion in match code
>     
>     Commit 8cc784ee (netfilter: change return types of match functions
>     for ebtables extensions) broke ebtables matches by inverting the
>     sense of match/nomatch.
>     
>     Reported-by: Matt Cross <matthltc@us.ibm.com>

Argh, I totally skimmed past this mistake earlier!
Should be:
	Reported-by: Matt Cross <matt.cross@gmail.com>

I just directed Matt Cross to the appropriate mailing list.

Cheers,
	-Matt Helsley

