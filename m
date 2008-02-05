Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbYBEVv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbYBEVv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbYBEVvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:51:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53798 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761297AbYBEVvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:51:03 -0500
Date: Wed, 6 Feb 2008 00:50:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glenn Griffin <ggriffin.kernel@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080205215027.GA24275@2ka.mipt.ru>
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com> <20080205155558.GA23145@one.firstfloor.org> <c9e534200802051029u5d08cf6dm54866f769e362262@mail.gmail.com> <20080205200211.GA26150@one.firstfloor.org> <20080205203911.GA9891@2ka.mipt.ru> <20080205205345.GA20920@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205205345.GA20920@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 09:53:45PM +0100, Andi Kleen (andi@firstfloor.org) wrote:
> > How does syncookies prevent windows from growing?
> 
> Syncookies do not allow window scaling so you can't have any windows >64k

Then you meant not windows change, but the fact, that option is ignored
as long as sack enable one?

> > Most (if not all) distributions have them enabled and window growing
> > works just fine. Actually I do not see any reason why connection
> > establishment handshake should prevent any run-time operations at all,
> > even if it was setup during handshake.
> 
> TCP only uses options negotiated during the hand shake and syncookies
> is incapable to do this.

What about fixing the implementation, so that it could get into account
different options too?

> -Andi

-- 
	Evgeniy Polyakov
