Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbXFOSBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbXFOSBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXFOSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:01:20 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:45254 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750755AbXFOSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:01:18 -0400
X-YMail-OSG: QiDbOnEVM1nTce7gI67.2XjABZyCGWOEQNYmESsjqxrl5W0qJPw_Hta7tvj4xjgCfzZuUcE_fg--
X-RocketYMMF: rancidfat
Date: Fri, 15 Jun 2007 11:01:18 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070615165054.GA11345@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <230452.63481.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Greg KH <greg@kroah.com> wrote:


> A daemon using inotify can "instantly"[1] detect this and label the file
> properly if it shows up.

In our 1995 B1 evaluation of Trusted Irix we were told in no
uncertain terms that such a solution was not acceptable under
the TCSEC requirements. Detection and relabel on an unlocked
object creates an obvious window for exploitation. We were told
that such a scheme would be considered a design flaw.

I understand that some of the Common Criteria labs are less
aggressive regarding chasing down these issues than the NCSC
teams were. It might not prevent an evaluation from completing
today. It is still hard to explain why it's ok to have a file
that's labeled incorrectly _even briefly_. It is the systems
job to ensure that that does not happen.


Casey Schaufler
casey@schaufler-ca.com
