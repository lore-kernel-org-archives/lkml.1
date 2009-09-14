Return-Path: <linux-kernel-owner+w=401wt.eu-S1751327AbZINEq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbZINEq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZINEq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:46:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59514 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZINEqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:46:55 -0400
Date: Mon, 14 Sep 2009 06:46:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not
	available
Message-ID: <20090914044657.GA4252@merkur.ravnborg.org>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com> <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com> <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com> <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com> <94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com> <8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com> <94a0d4530909131504h1a9de951k3719000705a86bbc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530909131504h1a9de951k3719000705a86bbc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 01:04:11AM +0300, Felipe Contreras wrote:
> On Mon, Sep 14, 2009 at 12:58 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> > .
> > On Sun, Sep 13, 2009 at 17:42, Felipe Contreras
> > <felipe.contreras@gmail.com> wrote:
> >> On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> >>> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
> >>>> +  if $domain; then
> >>>
> >>> is this really correct ?  i think you meant to use:
> >>> [ -n "$domain" ]
> >>
> >> What is the difference?
> >>
> >> $domain unset
> >> test -n "" -> false
> >> test -> false
> >>
> >> $domain is a valid string
> >> test -n "string" -> true
> >> test "string" -> true
> >
> > except that you didnt invoke `test` anywhere.  you're executing the
> > contents of $domain.
> 
> Ahh, I'll update it to:
> [ "$domain" ]

Please use [ -n "$domain" ].
Be explicit about what you do.

[Likewise in c we never omit "int" just because we can].

	Sam
