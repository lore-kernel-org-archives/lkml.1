Return-Path: <linux-kernel-owner+w=401wt.eu-S1765796AbXGYX0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765796AbXGYX0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbXGYX0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:26:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758542AbXGYX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:26:11 -0400
Date: Wed, 25 Jul 2007 16:25:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Masoud Sharbiani" <masouds@google.com>
Cc: "Andi Kleen" <ak@suse.de>, "Kirill Korotaev" <dev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-Id: <20070725162528.7d485ff8.akpm@linux-foundation.org>
In-Reply-To: <4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
References: <20070718154759.GA26425@google.com>
	<46A76210.5020903@openvz.org>
	<200707251657.44217.ak@suse.de>
	<20070725140455.cbbc0dde.akpm@linux-foundation.org>
	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 14:07:56 -0700
"Masoud Sharbiani" <masouds@google.com> wrote:

> On 7/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 25 Jul 2007 16:57:43 +0200
> > Andi Kleen <ak@suse.de> wrote:
> >
> > > On Wednesday 25 July 2007 16:45, Kirill Korotaev wrote:
> > > > plz don't enable it by default... :/
> > > > any user can spam syslog with these messages and if syslog is run as root
> > > > can take the whole diskspace...
> > >
> > > There are plenty of other ways to cause syslog messages anyways;
> >
> > tell us what they are and we'll fix them?
> >
> > > this argument is 100% bogus.
> >
> > people don't like leaving themselves open to logspamming.
> >
> >
> > For this particular issue: someone please send a patch.
> >
> Andrew,
> This is rate limited; Do you need me to rewrite it with it being
> disabled by default?
> 

Yes please.

Look: if there's a way in which an unprivileged user can trigger a printk
we fix it, end of story.  I don't know why this even slightly
controversial.

