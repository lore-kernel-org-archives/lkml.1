Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYJLONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYJLONW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYJLONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 10:13:09 -0400
Received: from 220-133-139-86.HINET-IP.hinet.net ([220.133.139.86]:49508 "EHLO
	cooldavid.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYJLONI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 10:13:08 -0400
From: "Guo-Fu Tseng" <cooldavid@cooldavid.org>
To: Jeff Layton <jlayton@redhat.com>, "Steve French" <smfrench@gmail.com>
Cc: rjw@sisk.pl, "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Reply-To: cooldavid@cooldavid.org
Subject: Re: [linux-cifs-client] Fwd: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Date: Sun, 12 Oct 2008 22:12:26 +0800
Message-Id: <20081012140936.M27503@cooldavid.org>
In-Reply-To: <20081012095903.33427ee8@tleilax.poochiereds.net>
References: <200810121315.37203.rjw@sisk.pl> <524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com> <20081012095903.33427ee8@tleilax.poochiereds.net>
X-Mailer: Open WebMail 2.51 20050228
X-OriginatingIP: 140.117.194.21 (cooldavid)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 09:59:03 -0400, Jeff Layton wrote
> On Sun, 12 Oct 2008 08:40:39 -0500
> "Steve French" <smfrench@gmail.com> wrote:
> 
> > Rafael and Guo-Fu,
> > The following change to address the compile error that you noted is
> > slightly different than what you suggested but should fix what you
> > found.
> >
> 
> Actually, I like Adrian/Rafael's fix better. I think we should avoid
> cluttering up the code with #ifdef's where possible. key_put() already
> is a no-op when CONFIG_KEYS is disabled. We might as well do the same
> thing with key_revoke().
I found that my patch was not reasonable at all.
And I agree with Jeff.

Guo-Fu Tseng

