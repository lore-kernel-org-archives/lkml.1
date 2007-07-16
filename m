Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbXGPNey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbXGPNey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932077AbXGPNeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:34:07 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:46010 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765348AbXGPNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:34:04 -0400
X-YMail-OSG: .yjqbS8VM1kJDc8n7fc1z_ny1QLOMe78ZQYwfzNpr23pTd7zn6tm1FeymE87QJEw1ZB9RNF_cg--
X-RocketYMMF: rancidfat
Date: Mon, 16 Jul 2007 06:34:03 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Including STRTOK_R in a LSM
To: "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au>,
       Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <469B626D.4060700@murdoch.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <214530.36096.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au> wrote:

> What I need is to ignore double delimiters such as (::). This can be 
> done trivially with a string comparison to check for "\0". What I want 
> to know is if it is ok to include the strtok_r code in my security 
> module, or if strtok was removed for a very good reason. I am porting a 
> lot of existing code which already uses strtok_r to a kernel security 
> module.

All over the Linux world little red flags are popping up.

Text processing of the sort that requires token parsing is rare
in the kinds of things the kernel is usually called upon to do.
You did mention, and someone else demonstrated, that there are
existing alternatives that you could adopt. Cluttering the kernel
with duplicate functionality is strongly discouraged.

As far as porting existing code into the kernel goes, be sure to
have a look at the official coding style before you show what you've
done to anyone. If you're porting "a lot" of code (Use SELinux as a
benchmark for an LSM. If you're bigger than that you have "a lot"
of code) you may also be putting too much into the kernel. Some
application programmers use programming methods that are not suited
to the kernel environment, so be careful that what you're doing and
the way you're doing it are appropriate to the kernel.

Best of luck.



Casey Schaufler
casey@schaufler-ca.com
