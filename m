Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbYAZQMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbYAZQMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYAZQBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:01:09 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:10473 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbYAZQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:01:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ppS7cz/Ro8EbIwOXdLg++hYNNOYnQK5POBKRO4w/14nEvXnOWYYLiz26e+vZJqnKsnTAad1qzDmvgo3rMv6p8m429ti0vrBEC51QV10NZL1AFx0L62lVTzHdiNGjsj5zpDblPC4RS+7n3xIjTNYB1tz30sdBgY43OP9zuieFv5Q=
Message-ID: <2f11576a0801260801n653142c5i1caa3ceed2fe01d4@mail.gmail.com>
Date: Sun, 27 Jan 2008 01:01:03 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: Kernel Event Notifications (was: [RFC] Parallelize IO for e2fsck)
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200801261655.31313.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <20080124234037.GJ15858@mit.edu>
	 <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
	 <200801261655.31313.a1426z@gawab.com>
X-Google-Sender-Auth: e312337b79df203b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al

> > the mem_notify patch can realize "just before starting swapping"
> > notification :)
> >
> > to be honest, I don't know fs guys requirement.
> > if lacking feature of fs guys needed, I implement it with presure if
> > you tell me it.
>
> These notifications are really useful, but it may be much wiser to pipe them
> thru some kevent-notification sub-system, instead of introducing kernel
> notifier-chain end-points left, right, and center.

Aaahh
Your feelings are understood well.
but current design is decided through many poeple discussion.

if anybody need kevent notification, I will add it to the current
implementation instead replace.

thanks.
