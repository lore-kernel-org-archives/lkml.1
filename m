Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZJ3ONA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZJ3ONA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbZJ3OM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbZJ3OM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:12:59 -0400
Date: Fri, 30 Oct 2009 15:12:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Vedran =?utf-8?B?RnVyYcSN?= <vedran.furac@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Memory overcommit
Message-ID: <20091030141250.GQ9640@random.random>
References: <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com>
 <4AE792B8.5020806@gmail.com>
 <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
 <4AE846E8.1070303@gmail.com>
 <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com>
 <4AE9068B.7030504@gmail.com>
 <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com>
 <4AE97618.6060607@gmail.com>
 <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com>
 <4AEAEFDD.5060009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AEAEFDD.5060009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 02:53:33PM +0100, Vedran Furač wrote:
> % free -m
>           total       used       free     shared    buffers     cached
> Mem:      3458        3429         29          0        102       1119
> -/+ buffers/cache:    2207       1251
> 
> There's plenty of memory available. Shouldn't cache be automatically
> dropped (this question was in my original mail, hence the subject)?

This is not about cache, cache amount is physical, this about
virtual amount that can only go in ram or swap (at any later time,
current time is irrelevant) vs "ram + swap". In short add more swap if
you don't like overcommit and check grep Commit /proc/meminfo in case
this is accounting bug...
