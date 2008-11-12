Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYKLBgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYKLBgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYKLBgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:36:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:49305 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYKLBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q4kyVx/FLYEEBDBJpqh5E4ePuEYon5klyC2YMA9+ZN0o2yHowKkPRN7QpEuciNrrz2
         GIBvSCLvXyHReTnRJxwVspzh3gdDSJXH6AGDo0OyvTcU5bp4Vc2Wd/7TN+gRZM3MOyOc
         WLONT6t0klBK+61iTEHylCwLbVizCoPvnauug=
Message-ID: <af0faace0811111736o4b6904acx9c25e06d4ebf3421@mail.gmail.com>
Date: Wed, 12 Nov 2008 09:36:43 +0800
From: "Pan ruochen" <panruochen@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: How kernel applies LRU to swap out physical pages?
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226403220.7685.1601.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
	 <1226393845.7685.1294.camel@twins>
	 <20081111180233.8B38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1226403220.7685.1601.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to all, I've have a study.

2008/11/11 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2008-11-11 at 18:56 +0900, KOSAKI Motohiro wrote:
>> > On Tue, 2008-11-11 at 16:22 +0800, Pan ruochen wrote:
>> > > Hi All,
>> > > I'm reading the linux kernel 2.6.14. But can't understand how LRU algorithm
>> > > is applied to page swapping. what is the 'USED' of LRU referred to? The
>> > > reference counter which the page is mapped by processes, or the frequency that
>> > > CPU reads/writes in the page. In common sense, the LRU algorithm will be more
>> > > optimal for the second case. But it depends on CPU capability.
>> > > I will be very appreciated if somebody can explain that in details.
>> >
>> > We don't actually use LRU but something like CLOCK.
>
> FWIW in case you hadn't found it yet:
>
>  http://en.wikipedia.org/wiki/Page_replacement_algorithm
>
> is a fairly decent page on the subject.
>
