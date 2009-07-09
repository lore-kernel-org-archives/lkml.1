Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbZGIM51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbZGIM51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760425AbZGIM5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:57:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56557 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004AbZGIM5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZA7XblgvOJynKKR6RaOdS53/yQOBc3WASsk8sZVQLJHk6Mm/kveuQpbV8gS6UL5snO
         h7AhTXfvOvCNgUFqYfe7RnGNKTmSXnclT08llicIafZ9ZmWmFXG63tz0lQvzjA4xu5VT
         xp6BZkjxO3qQJBfzTvmAtz1edKIBJHxzwBRTo=
MIME-Version: 1.0
In-Reply-To: <1247142266.9777.371.camel@twins>
References: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com> 
	<1247068556.9777.58.camel@twins> <193b0f820907080905u643e90ddi42a719e6163b0bc@mail.gmail.com> 
	<193b0f820907080939sf0bec93n16ee4b5aca6e1a7a@mail.gmail.com> 
	<193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com> 
	<1247142266.9777.371.camel@twins>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 9 Jul 2009 14:55:21 +0200
Message-ID: <193b0f820907090555j30106a1cx6e0fffd0c2a19691@mail.gmail.com>
Subject: Re: possible migration bug with hotplug cpu
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 14:24, Peter Zijlstra<peterz@infradead.org> wrote:
> One of the things I have wanted to do for a long time is to rename
> sched_entity to sched_fair_entity, and do something like:
>
> struct sched_entity {
>        struct sched_common_entity       common;
>
>        union {
>                struct sched_fair_entity fair;
>                struct sched_rt_entity   rt;
>        };
> };
>
> I imagine we can add struct sched_statistics to the end of this as well.
>
> The reason I haven't come around to doing this is that it takes a bit of
> time to refactor the code and find all the common bits. So its been on
> my todo list like forever.
>
> Can I persuade you to look at this? :-)

It looks like a very good idea. As you told, it will take a time to refactor
the code. I can look at this, but only on the end of next week.

> I'll queue the below, can I add:
>
> Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
>
> ?

Sure. I'm not very habituated yet with it... do I re-send the email
or you add it by yourself?

thanks

Lucas De Marchi
