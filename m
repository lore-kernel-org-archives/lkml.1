Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0BWUJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:09:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0BWUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:09:37 -0500
Date: Tue, 23 Feb 2010 12:09:35 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: netdev@vger.kernel.org
Subject: Peer unexpectedly shrunk window
Message-ID: <alpine.DEB.2.01.1002231154290.28195@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19Y5f5mtPYvYGFw/1fXHTtHaH8yjk7Ck83yk/S
 BLG5+xvjk6ReMJEeNRur3H5bX1lD8XUUPUWF6qeTlf9mgEio8w
 8fNYJK9P9+/FWBll2+cVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, the "Treason uncloaked" messages have been reworded[0][1] to now say 
"Peer [...] unexpectedly shrunk window", but the messages continue to 
appear. On a small Tor node (~100KB/s, ~200 connections) I'm getting ~2000 
or so messages per month in my kernel log (and on the console).

I see that it's logged with KERN_DEBUG, is there anyway to suppress 
those, i.e. some magic tcp specific bootparameter? Or is setting 
loglevel=6 the only way to supress them? But that's a global option :-\

Since the messages always say "repaired", why log them at all? If we can't 
do something about the remote side, I fail to see the point of these 
messages or what one is supposed to do to "fix" them.

Thanks for your insights,
Christian.

[0] http://lkml.org/lkml/2008/12/18/454
[1] http://kerneltrap.org/mailarchive/linux-netdev/2009/4/19/5518144
-- 
BOFH excuse #399:

We are a 100% Microsoft Shop.
