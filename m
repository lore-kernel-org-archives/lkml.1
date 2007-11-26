Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXKZOkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXKZOkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXKZOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:40:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:35571 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXKZOkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=plBROmJ1NsVrLeGGbhgOb86P8xZ7eEITgENzllqRdAJbfrDc2pV4TEbVwdfwy0VKhG5MlfFmUfAAQctoKl4ewBTBrh2uau8Gp0Q1I6NKxgyBc/Y4qyFl81LnbRchy0GvdxsAkU+Fkqjkdlc1jt0lCC4/ETY5xUeMwkfP5tH8egA=
Message-ID: <d120d5000711260640y68c6136fy181b63af85bf6ae6@mail.gmail.com>
Date: Mon, 26 Nov 2007 09:40:14 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Kristoffer Ericson" <kristoffer.ericson@gmail.com>,
       Dmitry <dmitry.torokhov@gmail.com>,
       "Russell King" <linux@arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding naming scheme (HP Jornada 6XX/7XX)
In-Reply-To: <20071126043030.GA25664@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071126000329.8e7304c5.Kristoffer.ericson@gmail.com>
	 <20071126043030.GA25664@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 25, 2007 11:30 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Nov 26, 2007 at 12:03:29AM +0100, Kristoffer Ericson wrote:
>
> > Why I want to use 600-series/700-series instead of 6XX/7XX is simply
> > because 600-series/700-series leaves no doubt.
> >
> Apparently your end users are more technically apt than I am, as I have
> no idea how using 00 over XX makes things any less ambiguous.
>
> We already have a 6xx mach-type that drivers can set their dependency on.
> If it's not 680-only, then that's a perfectly reasonable dependency. Feel
> free to change the Kconfig text to make the description more useful, but
> please don't start idly shuffling around code and symbols because users
> can't work out why a driver is available that they can't support.

Agreed. Users simply should not care what a particular module is
called. If Kconfig entries and/or its help is unclear on whta devices
are supported by the drivers let's fix that.

-- 
Dmitry
