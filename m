Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbXJYRP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbXJYRP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXJYRPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:15:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35123 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXJYRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:15:10 -0400
Date: Thu, 25 Oct 2007 10:10:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Bernd Petrovitsch" <bernd@firmix.at>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
 static interface)
Message-ID: <20071025101051.271072a1@laptopd505.fenrus.org>
In-Reply-To: <2c0942db0710250904n71a6c3dfk5dbc2a91f457ab05@mail.gmail.com>
References: <20071024223124.GI30533@stusta.de>
	<446110.89443.qm@web36608.mail.mud.yahoo.com>
	<20071025002356.GB3660@sequoia.sous-sol.org>
	<2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	<1193303990.18559.28.camel@tara.firmix.at>
	<2c0942db0710250904n71a6c3dfk5dbc2a91f457ab05@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 09:04:57 -0700
"Ray Lee" <ray-lk@madrabbit.org> wrote:


> Security is not an all or nothing game, it's layers. And we have to
> make sure that the layers are usable without taking a course from the
> NSA. I'd love to see a poll of the kernel development community to
> find out how many use SELinux on their machines, for example.

I absolutely agree it's a layer game.
HOWEVER, even in a layer game we need to have each layer to be
reasonably solid and not just fake security ("snakeoil").

So while I think it is entirely fair to judge a piece of software
against what it intends/claims to do, because other pieces in the layer
game will depend on it to function reasonably well. 

So most of the LSM fist-fights have been about disagreement of the
intent; and some about code not living up to its own intend, all mixed
up. Arguing about the intent is less productive imo (as long as it's at
least somewhat reasonable, intend like "I want to add rootkits" doesn't
count obviously), paying attention to check if the code lives up to its
stated intent/purpose on the other hand is immensely useful and needed;
for a given implementation it may mean reducing the scope of the intent
if the implementation just doesn't go as wide as originally thought, or
fixing some issues in the implementation to live up to the intent.
