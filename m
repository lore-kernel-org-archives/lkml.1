Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbXF0WO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbXF0WO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbXF0WOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:14:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076AbXF0WOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:14:16 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Patch Related With Fork Bombing Attack
To: Anand Jahagirdar <anandjigar@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 28 Jun 2007 00:14:08 +0200
References: <8Alj9-41R-7@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I3fm4-00010y-NL@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19fiK+ClOguUMlrKS8S6I6V/Yc/1a42JSnE4Y2
 ni9ebW4R3w+8StpyeRhUUDnaAH/LeicfBzfLtx6Amatf+uAvxC
 z+WsArxQ7OX2khgAwGLfQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(not CCing security, since it's not a security bug and it's too late to
 verify if they should be on cc. Will do later.)

Anand Jahagirdar <anandjigar@gmail.com> wrote:

> This patch Warns the administrator about the fork bombing attack
> (whenever any user is crossing its process limit). I have used
> printk_ratelimit function in this patch. This function helps to
> prevent flooding of syslog and prints message as per the values set by
> root user in following files:-
> 
> 1) /proc/sys/kernel/printk_ratelimit:- This file contains value for,
> how many times message should be printed in syslog.
[...]

I'm wondering: Can these ratelimits be used to tell real forkbombs from
normal oops-i-hit-the-limits? I imagine if you have your private ratelimit,
that might just do the trick.

Beware: I have no idea on how much such an extra ratelimit would cost, and if
having that ratelimit-based detector would actually be a gain.
-- 
Ever notice how fast Windows runs? Neither did I. 

Friﬂ, Spammer: .w@7eggert.dyndns.org N@zu.0vJB.7eggert.dyndns.org
 99aLZMlkFe@YE.7eggert.dyndns.org Bbga@PKDpIYua.7eggert.dyndns.org
