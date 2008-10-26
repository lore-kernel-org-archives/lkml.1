Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYJZSjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYJZSjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYJZSjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:39:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYJZSjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:39:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: kerneloops.org: 2.6.28-rc regression in epoll (list corruption)
Date: Sun, 26 Oct 2008 19:43:56 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       davidel@xmailserver.org, Andrew Morton <akpm@linux-foundation.org>
References: <20081026112920.28e7dccc@infradead.org>
In-Reply-To: <20081026112920.28e7dccc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261943.56829.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Arjan van de Ven wrote:
> This one is upcoming fast (and I just hit it as well)
> 
> http://www.kerneloops.org/searchweek.php?search=ep_poll_callback
> 
> seems epoll grew some list corruption....

Yes, I think this is http://bugzilla.kernel.org/show_bug.cgi?id=11831 and
there's a patch from Davide fixing this bug, at:
http://lkml.org/lkml/2008/10/17/491

Thanks,
Rafael
