Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbXIBXay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbXIBXay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 19:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXIBXaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 19:30:46 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:48806 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753323AbXIBXap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 19:30:45 -0400
X-YMail-OSG: 3pUZ06cVM1nQ9RzF8zS9LNuOhFzFYUWg2LnUJmZVpLU8KUoARCJbMCpp.ds9KsRJLQ--
X-RocketYMMF: rancidfat
Date: Sun, 2 Sep 2007 16:30:44 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Get source and destination info
To: Shahbaz Khan <shaz.linux@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, selinux@tyco.nsa.gov
In-Reply-To: <20cbb9450709021618o42ae8047k10e52e880c97a0a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <711567.2389.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Shahbaz Khan <shaz.linux@gmail.com> wrote:

> Hi,
> 
> I am trying to figure out what part in the kernel code is the point
> from where I can get source and destination ip-address, port, security
> labels (selinux etc) from a packet before I export it to application
> space for my needs. Any hints?

Look into the netlabel and xfrm code. In Smack it gets dealt with
in smack_lsm.c, but Smack only uses netlabel. SELinux spreads the
handling into a number of files, including hooks.c, netlabel.c, xfrm.c,
and ss/services.c.


Casey Schaufler
casey@schaufler-ca.com
