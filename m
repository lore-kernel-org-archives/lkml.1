Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXJHAMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXJHAMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 20:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXJHAMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 20:12:33 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:44727 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750910AbXJHAMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 20:12:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wIxxqYg/wTBz4i//fTRZg8NosGz+CBZ2Yo3LgfADIpYIN5XQ12mqcMTWe/3u4ARgT/gAveX6P3r26SZepP7BOJJTcWCH90Bhe0ZKUiP5DJdrWD4ShQ3vcO/8uGA2tcYxiIdd4SW0HOPZagWP9E3Zh6tJOlEbfBQC9J1haQBwNMc=  ;
X-YMail-OSG: jptVOjgVM1mAxHWZd8sz2gZJEAFUmngfOAMhIpBxzjo3foCQnp4RNTtPKukkEgHN81YSgMtxuA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [DEBUG PATCH] demonstration of hang in sched domain partitioning code
Date: Sun, 7 Oct 2007 17:40:46 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Cliff Wickman <cpw@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
References: <20071005092432.32047.60952.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20071005092432.32047.60952.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071740.47377.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 19:24, Paul Jackson wrote:
> Nick,
>
> I'm running into a problem trying to use your suggested
> partition_sched_domains(cpumask_t *partition) routine the way
> I thought I was supposed to be able to use it.
>
> If I ask to set up the same partition twice in a row having
> just one CPU in it (a singleton) the kernel hangs.
>
> I don't know enough about kernel/sched.c to be able to debug
> this very efficiently.  Any chance you could take a look?

Hi Paul,

Yeah I'll take a look. Meanwhile, as Ingo said, the recent patch you
sent is reasonable enough because the most critical thing to do is
to allow users to move away from the old interface.

