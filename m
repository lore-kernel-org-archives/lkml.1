Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXEYTGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXEYTGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEYTGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:06:22 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:34163 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753733AbXEYTGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:06:21 -0400
X-YMail-OSG: Ub4Cl.4VM1k8B_ud_txcJYnhyQaKaLyJcfTL6tzWE68nd18K35K5yuGf490CofTKjK0JU9xPfw--
X-RocketYMMF: rancidfat
Date: Fri, 25 May 2007 12:06:19 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <87fy5kpye6.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <770093.5988.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jeremy Maitin-Shepard <jbms@cmu.edu> wrote:

> ...
> Well, my point was exactly that App Armor doesn't (as far as I know) do
> anything to enforce the argv[0] convention,

Sounds like an opportunity for improvement then.

> nor would it in general
> prevent a confined program from making a symlink or hard link.  Even
> disregarding that, it seems very fragile in general to make an suid
> program (there would be no point in confining the execution of a
> non-suid program) perform essentially access control based on argv[0].

I think that you're being generous calling it fragile, but that's
my view, and I've seen much worse. I agree that it would be a Bad Idea,
but the fact that I think it's a bad idea is not going to prevent very
many people from trying it, and for those that do try it name based
access control might seem like just the ticket to complete their
nefarious schemes. Remember that security is a subjective thing, and
using argv[0] and AppArmor together might make some people feel better.



Casey Schaufler
casey@schaufler-ca.com
