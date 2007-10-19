Return-Path: <linux-kernel-owner+w=401wt.eu-S967049AbXJSVT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967049AbXJSVT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966709AbXJSVTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:19:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966646AbXJSVTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:19:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] Freezer: Do not allow freezing processes to clear TIF_SIGPENDING
Date: Fri, 19 Oct 2007 23:34:51 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200710190022.36145.rjw@sisk.pl> <20071019075555.GA9756@elf.ucw.cz>
In-Reply-To: <20071019075555.GA9756@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192334.52669.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 19 October 2007 09:55, Pavel Machek wrote:
> On Fri 2007-10-19 00:22:35, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
> > to prevent them from racing with the freezer (like mysqld does, for example).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACK. We want this in 2.6.24.

Sure, we do.

Greetings,
Rafael
