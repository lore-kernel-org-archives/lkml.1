Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYG3Gwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYG3Gwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYG3Gwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:52:43 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:26573 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751075AbYG3Gwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:52:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yHVOkdMRbTlCKCQFBN+TvUPXLqj/wf7SpDHkc+Dr9l12qX/PqXG8E5pfpHRmhkYVxIWq4mpXMfY7L7Xivg7APlnxNxr2bdhih+Kky2051Ysg6r3cFk5CB/5xjKzXTT5oflzur7yudI0j/HBuq/DTWslklM3BWH+OBJAUKb0lC5k=  ;
X-YMail-OSG: j7wmeAkVM1mc.F1L11.zMGORRdjYR2iEJ53xOKNFcE0SYRhDdrqzhu7NkatYUBTNsR2ccNwoi1sfXlwOgbABtlrodcQG46sjvYkMJO1Ley.HIr5kEJPKFKQC6XqgBCeENaA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: hooanon05@yahoo.co.jp
Subject: Re: bug? 2.6.26-rc8-mm1, corrupted dcache
Date: Wed, 30 Jul 2008 16:52:22 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <9886.1217400028@jrobl>
In-Reply-To: <9886.1217400028@jrobl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301652.23024.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 16:40, hooanon05@yahoo.co.jp wrote:
> Hello,
>
> A filesystem stress test script racer.sh caused a problem in
> 2.6.26-rc8-mm1. I am not sure it is caused by some changes to memory
> management or handling dentry in proc_flush_task_mnt().
> Is this problem already known and fixed?

This looks a bit like the PREEMPT_RCU problem that was fixed just
before 2.6.26. Do you have PREEMPT_RCU=y and HOTPLUG_CPU=n in your
config?
