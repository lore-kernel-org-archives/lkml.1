Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbXLRQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbXLRQng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbXLRQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:43:14 -0500
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:39172 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757610AbXLRQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:43:13 -0500
X-YMail-OSG: CCpZM2gVM1mUlhvOnOJgvf9O19DpehDbNGMNH0WQdN6HZI9uIIxsGvyN_mEo3Z5d20eU65qjwQ--
X-RocketYMMF: rancidfat
Date: Tue, 18 Dec 2007 08:43:11 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
To: Valdis.Kletnieks@vt.edu, Pavel Machek <pavel@ucw.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <22795.1197993320@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <968709.86780.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Valdis.Kletnieks@vt.edu wrote:

> On Thu, 06 Dec 2007 15:29:07 GMT, Pavel Machek said:
> > 
> > > Why not use SELinux?
> > > 
> > >  Because SELinux doesn't guarantee filename and its attribute.
> > >  The purpose of this filesystem is to ensure filename and its attribute
> > >  (e.g. /dev/null is guaranteed to be a character device file
> > >  with major=1 and minor=3).
> > 
> > Why not improve selinux to be able to assign label of new file based
> > on directory label and name?
> 
> The problem isn't the label, it's the *other* attributes...
> 
> What happens if /dev/null has the correct SELinux label, but the major/minor
> is 1,27 rather than 1,3?

Isn't this the kind of thing that Bastille is good for?


Casey Schaufler
casey@schaufler-ca.com
