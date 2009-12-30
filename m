Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZL3Kwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZL3Kwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 05:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZL3Kwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 05:52:31 -0500
Received: from www84.your-server.de ([213.133.104.84]:33110 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZL3Kwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 05:52:30 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vikram Dhillon <dhillonv10@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <20091230104325.GA2214@core.coreip.homeip.net>
References: <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e> <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
	 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
	 <20091230020830.GA7049@core.coreip.homeip.net>
	 <1262165390.4153.3.camel@wall-e>
	 <20091230104325.GA2214@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 30 Dec 2009 11:52:15 +0100
Message-ID: <1262170336.9121.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 30.12.2009, 02:43 -0800 schrieb Dmitry Torokhov:
> On Wed, Dec 30, 2009 at 10:29:50AM +0100, Stefani Seibold wrote:
> >
> I do not need to try the new behavior - you explained it quite well.
> You changed the old API to allow processing multiple records at a time
> and it does not quite work the way you want with Andi's patch. Now the

Wrong, i did not change the behavior of the old API. It is exactly the
same at is was!!!!

> question is: when working with _records_ does anyone really want to
> put/get more than 1 record at a time? My answer would be "no, most users

Your answer is wrong. All current user depend on it, because it
(miss)use a byte stream to store values other than bytes to it.
 
> work with 1 record at a time". Thus your changes to the old API are not
> needed.
> 

A lot of hot air... Better you check the code before complain.

Stefani


