Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXFIShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXFIShj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXFIShb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:37:31 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:20250 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756878AbXFISha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:37:30 -0400
X-YMail-OSG: qupuWggVM1kxe7e87dtmOaVAJfUBa6mvA0PieW7K446_C05qsqD._aDJvUET7ZZYS.D5DJG2vg--
X-RocketYMMF: rancidfat
Date: Sat, 9 Jun 2007 11:37:29 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
To: Sean <seanlkml@sympatico.ca>, david@lang.hm
Cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20070609032822.bc420a84.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <637419.18785.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Sean <seanlkml@sympatico.ca> wrote:


> The question is: why not just extend SELinux to include AA functionality
> rather than doing a whole new subsystem.

Because, as hard as it seems for some people to believe,
not everyone wants Type Enforcement. SELinux is a fine
implementation of type enforcement, but if you don't want
what it does it would be silly to require that it be
used in order to accomplish something else, like name based
access control.

If the same things made everyone feel "secure" there would be
no optional security facilities (audit, cryptfs, /dev/random, ACLs).
It appears that the AA folks are sufficiently unimpressed with
SELinux they want to do something different. I understand that
there is a contingent that believes security == SELinux. 
There are also people who believe security == cryptography or
security == virus scanners. I'm happy that they have found what
works for them.

Also, "just extend" implies that it would be easy to do. I
suggest you go read the SELinux MLS code, and go read some
of the discussions about getting MLS working for the RedHat LSP
before you go throwing "just" around.


Casey Schaufler
casey@schaufler-ca.com
