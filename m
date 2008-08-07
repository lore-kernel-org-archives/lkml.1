Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYHGPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYHGPFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYHGPFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:05:38 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50360 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYHGPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:05:37 -0400
Message-Id: <1218121536.20866.1267493005@webmail.messagingengine.com>
X-Sasl-Enc: 51JSNJuiBY+TrnnOg7jRutTa433iVM6y3eBEqBQuWojI 1218121536
From: "Kai" <epimetreus@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mike Galbraith" <efault@gmx.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
 <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com>
 <1206341873.32060.1243929851@webmail.messagingengine.com>
 <20080327091711.GD30918@elte.hu>
 <1207250856.9779.1245934881@webmail.messagingengine.com>
 <20080421155339.GC31716@elte.hu>
Subject: Re: Serious performance regression in Wine applications and Linux      
 2.6.24.*
In-Reply-To: <20080421155339.GC31716@elte.hu>
Date: Thu, 07 Aug 2008 08:05:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some stuff came up and I was unable to focus on this bug for a while,
but it's gone as of 2.6.26. Performance is comparable to 2.6.23 once
again, maybe a bit better in places.

On Mon, 21 Apr 2008 17:53:42 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Kai <epimetreus@fastmail.fm> wrote:
> 
> > I did, however, test it on 2.6.25-rc8, and attached is the output of 
> > cfs-debug-info.sh
> 
> your vmstat:
> 
> -- vmstat: 
> --procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
>  id wa
>  3  0      0 870540    340 746184    0    0   952   137  198 4752 21 12
>  60  7
>  1  0      0 870952    340 746320    0    0   128     0  356 17723 28 23
>  50  0
>  1  0      0 872224    340 746320    0    0     0    21  394 18066 30 20
>  50  0
>  1  0      0 872244    340 746320    0    0     0     0  353 17987 29 22
>  50  0
>  1  0      0 871416    340 746320    0    0     0     0  392 17971 28 22
>  50  0
> 
> suggests that there's a constant 50% idle time. Probably one core 
> running X and the client, the other core staying idle?
> 
> 	Ingo
