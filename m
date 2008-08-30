Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYH3At2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYH3At2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYH3AtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:49:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:37116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYH3AtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=P+ZZg4XIv8AjPNoUyXPRaW6nunhb1iDmXSfr/85A7uP93CcDdMC/kQZD3/970m2VHs
         /SHcAMiSgEJvQSRUqwB7odixJB+D4lGHN9IsKygFzpC0JGzR1OPHApTixu6oRMtWficd
         8ijS1b80tyq5xdsNRNW+ixMMNVEGe3wOl6x0Y=
Message-ID: <2f11576a0808291749s6a154a49nea191f16bd5e6756@mail.gmail.com>
Date: Sat, 30 Aug 2008 09:49:17 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Subject: Re: VM: page reclaim does not work on ARM9? [resend]
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <462ADBE7F1A69C438B7E2ED56007E6F5ABF9A43F2B@exch10.BC-Int.NET>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Ach0m4cSiApNdLdFScC3DSTHVH8H7w==>
	 <462ADBE7F1A69C438B7E2ED56007E6F5ABF9A43F2B@exch10.BC-Int.NET>
X-Google-Sender-Auth: 2cf20101fdcc7dfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My expectation was: the VM shall steal (reclaim) all the
> only once touched pages containing those dumb linear code of
> the app.
>
> My observation is: "top" shows that the app is consuming
> constantly the same huge amount of residential memory during
> the decreasing free memory space. At some moment the kernel
> starts a OOM killer on the app instead of reclaiming its
> unused code pages.

I guess this isn't code pages.
So, Can you observe /proc/{pid}/smaps file?

it tell you detail of these pages.


Thanks.
