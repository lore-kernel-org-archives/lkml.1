Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZJVN7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZJVN7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZJVN7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:59:04 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:33910 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbZJVN7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YP+9qf0SXJ2lYGnfBcA0qP9KW5hfehFI7ibKx1kEHEdEHjdAs/u9VyYKzXo4ZK4XDf
         nU9dBD/Qqqz6kUS0AfemwDI1zVuxvkQfCj5/gA9HEDALc6ua5SdeK0W7ZH8CZ1JWJKrZ
         t6+CadL6pPRoFC5mbXiWj0UxN2y7awyY3skxo=
MIME-Version: 1.0
In-Reply-To: <20091022070527.GE2211@elf.ucw.cz>
References: <20091019213751.GC1482@ucw.cz> <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com> 
	<20091022070527.GE2211@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 22 Oct 2009 21:58:47 +0800
Message-ID: <f17812d70910220658t5bbd5d02n5f4a37c1c7670cff@mail.gmail.com>
Subject: Re: spitz backlight: fix brightness limiting
To: Pavel Machek <pavel@ucw.cz>, Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@osdl.org>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 3:05 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2009-10-22 04:20:34, Eric Miao wrote:
>> It's a little bit weird it's called 'limit_mask' when I first converted it
>> to a spi driver. There must be some reasons, Richard, you've got
>> any ideas?
>
> Yes, the code was "interesting"...
>
> I can certainly do the rename, but maybe we can fix the issue now and
> do futher cleanups later?

Fair enough, I'm fine with that - I'd like this to go through Richard's
backlight tree if possible, though.
