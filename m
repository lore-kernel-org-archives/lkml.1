Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753145AbYLQTb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYLQTb3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYLQTaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:30:04 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56685 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYLQT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=sbYr/AIYf4ynHnaWjqxhSj4mcPXZv3UejFjdq24gWvD8Et82uL4GyxQPQ+0yTkEIwm
         CZx626SGIAc/mXsEgphxA+lwmrPpMITuzUUs0hUKEdk4Ls0CkyfdYIF4t19iUMw5/Cdh
         BhnSwjMAsyuuGodzPZfvWkHajkpPMl3oJjhXA=
Date: Wed, 17 Dec 2008 20:29:56 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/9] ide-atapi: remove ide_atapi_pc from the irq handler
Message-ID: <20081217192956.GA6316@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com> <200812162135.27902.bzolnier@gmail.com> <20081217072543.GA828@gollum.tnic> <200812171745.41830.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812171745.41830.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> [ Yes, I'm a bit disappointed that 2.6.29 is going to be the next release
>   that we will miss on ide-cd -> ide-atapi conversion (I was initially
>   hoping for .28) and the fact that in few weeks this will become a limiting
>   factor to the further progress on core IDE changes (despite few issues
>   to still take care of things are starting to look really well there)... ]

ok, I get the idea, and I'm sorry for mis-prioritizing the things we
have to work on but it's not like I've been idling - as you're well
aware, we had a couple of nasty bugs in the past months which had to be
taken care of.

Anyways, I don't think it is too late yet for .29 since the merge window
is not open yet and I might whip up some patches in the next couple of
days...

-- 
Regards/Gruss,
    Boris.
