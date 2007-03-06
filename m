Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXCFJNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXCFJNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbXCFJNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:13:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:38508 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156AbXCFJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fVKbJjHPnJRmKQJxP4fZTnWXZfsLazgNXcENI8i57V187nVLlxsEKTEBYYMkK8mGXkm3UILfNT1G7t79EIraqnNpjAuNdVBQVd9sf6tTHHx9x3uNePmS0GWORgnag91lU2Dinja44xPX9eDTvokc/22QUOxhn0DOhJw0to6KKcI=
Message-ID: <df9815e70703060113w8eeeae3g6fc9ce6190eb380c@mail.gmail.com>
Date: Tue, 6 Mar 2007 17:13:07 +0800
From: albcamus <albcamus@gmail.com>
To: Mockern@yandex.ru
Subject: RE: Question: schedule()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45ED23E3.000004.17474@webmail18.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED23E3.000004.17474@webmail18.yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

your kthread IS preemptible unless you call preempt_disable or some
locking functions explicitly .

Regards,
albcamus

2007/3/6, Mockern <Mockern@yandex.ru>:
> Hi,
>
> What does schedule() function do? I want to make my kthread preemptive.
>
> Thanks
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
