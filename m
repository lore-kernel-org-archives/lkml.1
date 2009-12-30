Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZL3J36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZL3J36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZL3J36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:29:58 -0500
Received: from www84.your-server.de ([213.133.104.84]:53811 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZL3J35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:29:57 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vikram Dhillon <dhillonv10@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <20091230020830.GA7049@core.coreip.homeip.net>
References: <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e> <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
	 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
	 <20091230020830.GA7049@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 30 Dec 2009 10:29:50 +0100
Message-ID: <1262165390.4153.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Dec 29, 2009 at 08:18:50PM -0500, Vikram Dhillon wrote:
> > IMHO you can process elements rather than bytes, which is a good
> > improvement, but then again its my opinion, if others don't like it
> > then we can always change it :D
> 
> Right, I was not arguing against having a record-oriented interface, I
> was questioning the utility of processing several records at a time.
> Kfifo users that I have seen so far were working in a record-at-a-time
> mode.
> 

Fascinating, i get a lot of comments, but no one is trying the new macro
base implementation. If someone would, this person would see, that is
100% compatible to the current one and absolut easy to use. Please try
it first bevor argue and complain.

Stefani


