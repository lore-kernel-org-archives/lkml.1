Return-Path: <linux-kernel-owner+w=401wt.eu-S936176AbXHLRsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936176AbXHLRsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765249AbXHLRsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:48:09 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:48704 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764726AbXHLRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:48:08 -0400
X-YMail-OSG: On7_CrsVM1kCYFFN0qdrE.gs7ohJbf1PYz2EHvd4e5aJa2Ez
X-RocketYMMF: rancidfat
Date: Sun, 12 Aug 2007 10:48:05 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Andi Kleen <andi@firstfloor.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <20070812114913.GA20669@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <918222.44901.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:

> > Entries are never deleted, although they can be modified.
> 
> The modification case still seems racy then.

Fair enough. I'll look into real list management.


Casey Schaufler
casey@schaufler-ca.com
