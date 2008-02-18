Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYBRCfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYBRCfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYBRCfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:35:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44345
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbYBRCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:35:44 -0500
Date: Sun, 17 Feb 2008 18:36:21 -0800 (PST)
Message-Id: <20080217.183621.110686685.davem@davemloft.net>
To: jkosina@suse.cz
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org, panther@balabit.hu,
       torvalds@linux-foundation.org
Subject: Re: My system stops during startup with curretn git tree of
 2.6.25-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802171301430.7699@twin.jikos.cz>
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com>
	<Pine.LNX.4.64.0802171301430.7699@twin.jikos.cz>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Sun, 17 Feb 2008 13:04:59 +0100 (CET)

> On Sun, 17 Feb 2008, Zdenek Kabelac wrote:
> 
> > It looks like there is something weird as my systems stops when the swap 
> > is mounted. I've played bisection game and this is the commit which 
> > makes the system unusable:
> > # bad: [45b503548210fe6f23e92b856421c2a3f05fd034] [RTNETLINK]: Send a
> > single notification on device state changes.
> > git-bisect bad 45b503548210fe6f23e92b856421c2a3f05fd034
> > I've tried to reverse this commit - and it has compiled & worked.
> 
> This commit is completely broken (it, for example, breaks locking around 
> dev->link_mode), as has been already mentioned by Rafael at 
> http://lkml.org/lkml/2008/2/15/542
> 
> Dave, do you have a proper fix queued? Otherwise I would propose just to 
> revert it completely from Linus' tree for now.

I just reverted and I'll push that to Linus.
