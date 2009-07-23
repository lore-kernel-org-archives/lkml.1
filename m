Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZGWP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZGWP7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZGWP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:59:40 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:49755 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZGWP7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=dddAggNL8sG/aGWcnf2A45J5+Kj3l4kPXjlm0jyyelJOfAkqrjTgVUSoakwn4UsMZt
         8Da+bgERcm9wncqki99rVQX5viKxtKa0hCIQmkt9wIPq6iODHmvv5vPe/tMWf8fEEIGN
         /nPAPRr1FSQ0xkomk7lCcepPFiTPcGbIp/ppU=
MIME-Version: 1.0
In-Reply-To: <1248331306.13472.25.camel@marge.simson.net>
References: <1248090981.18702.14.camel@marge.simson.net> <1248274190.27058.1530.camel@twins> 
	<1248281171.5738.5.camel@marge.simson.net> <1248287763.8266.15.camel@marge.simson.net> 
	<1248331306.13472.25.camel@marge.simson.net>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Thu, 23 Jul 2009 08:59:18 -0700
X-Google-Sender-Auth: 5f18b5e1cd4b274e
Message-ID: <2c0942db0907230859j13cf14bcl179e883fe5d990c8@mail.gmail.com>
Subject: Re: [patch] perf_counter tools: resurrect perf top annotation in a 
	simple interactive form
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:41 PM, Mike Galbraith <efault@gmx.de> wrote:
> > Hm, that is lame though, so updated patch below.  If an unknown key is
> > poked, display known keys, and wait for the user to poke one that _is_
> > known.  If you know the keys, you don't have to look at annoying legend,
> > if you forget, tap space or whatever.
>
> I leered at it again this morning, and changed it a wee bit more.
> Hitting an unknown key displays keys and current settings, and prompts
> for input.  Hitting space allows you to cancel entry.

Whenever I get a menu I didn't want, my finger reaches for ESC of its
own volition. Just a thought.
