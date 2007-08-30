Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXH3Jtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXH3Jtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbXH3Jtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:49:39 -0400
Received: from web32615.mail.mud.yahoo.com ([68.142.207.242]:32898 "HELO
	web32615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757373AbXH3Jti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:49:38 -0400
X-YMail-OSG: _EkXCr0VM1mr_heLgPLScSVZaTwlelR_1FoCqcAN6GJVQben_CE4GntA74HDZ5Bng_idVaN6_iiDhWgYvFcKa1Ao3A--
X-RocketYMMF: knobi.rm
Date: Thu, 30 Aug 2007 02:49:37 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: RE: regression of autofs for current git?
To: linux-kernel@vger.kernel.org
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <777806.79381.qm@web32615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 20:09 -0700, Ian Kent wrote:
>
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75180df2ed467866ada839fe73cf7cc7d75c0a22
>
>This (and it's related patches) may be the problem.
>I can probably tell if you post your map or if you strace the
automount
>process managing the a problem mount point and look for mount
returning
>EBUSY when it should succeed.

 Likely. That is the one that will break the user-space automounter as
well (and keeps me from .23). I don't care very much about what the
default is, but it would be great if the new behaviour could be
globally changed at run- (or boot-) time. It will be some time until
the new mount option makes it into the distros.

Cheers
Martin
PS: Sorry, but I likely killed the CC list


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
