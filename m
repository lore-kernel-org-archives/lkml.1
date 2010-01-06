Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740Ab0AFMAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab0AFMAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 07:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533Ab0AFMAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 07:00:08 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:34422 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0AFMAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 07:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oNwYn6rE8haUi6IwD1d9n2dubfz4jnWlQGR1dX2sMvKW99ci52FdHTAhcf7wSA1cbK
         LVJzAFDw6O/pFpLGnKu0+4bCSGDisS4xr2i2fsIiWtRiMw/7oT9GS5cpqNvOql8rlU/h
         G9g/6pSRsJwnUN9xrHzyIF6ahfY3TrSIHRUnY=
MIME-Version: 1.0
In-Reply-To: <4B447836.9020004@suse.cz>
References: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com> 
	<4B445D3E.8080600@suse.cz> <f17812d71001060231l5c0ca1bha50e395790d0fc0b@mail.gmail.com> 
	<4B44684B.1060401@suse.cz> <f17812d71001060322j4970349ex52f0cfa495ac8628@mail.gmail.com> 
	<4B447836.9020004@suse.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jan 2010 19:59:47 +0800
Message-ID: <f17812d71001060359o463448den4c19cafd2dff9834@mail.gmail.com>
Subject: Re: [PATCH] kbuild: include only necessary in scripts/Makefile.modbuiltin
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 7:47 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 6.1.2010 12:22, Eric Miao wrote:
>> And indeed it's strange - while scripts/Makefile.build doesn't fail since
>> there seems to be a script that generates some Makefiles in between
>> the build process, I'll get this figured out to see what is the root
>> cause.
>
> Oh. If that turns out to be the cause and the script is going to stay,
> then the right fix would be to change the toplevel Makefile generate the
> modules.builtin files in a separate target after the build, and not in
> parallel. I planed to do this change anyway, to later avoid regenerating
> the modules.builtin files if the config didn't change.
>

That will be great, I'd be happy to give a test then.
