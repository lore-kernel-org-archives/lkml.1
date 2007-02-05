Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbXBEUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbXBEUX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933420AbXBEUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:23:28 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:45317 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933415AbXBEUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:23:26 -0500
X-YMail-OSG: mYTdXdsVM1m_PYmaQHSNRoXib80hVfrPO5lhAE7AhqNdSWwhf4uueHOrMR3a_cKO1g--
X-RocketYMMF: rancidfat
Date: Mon, 5 Feb 2007 12:23:24 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
To: Chris Wright <chrisw@sous-sol.org>
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, agruen@suse.de
In-Reply-To: <20070205195058.GT10475@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <96672.70902.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Wright <chrisw@sous-sol.org> wrote:


> It's not really worth describing, since it's not
> acceptable in upstream.
> But it basically cycles vfsmnts and looks for
> matches to guess which
> part of the tree the dentry is in.

Yick. Indeed, that would be bad.

> This kind of change (or perhaps
> straight to struct path) is definitely
> needed from AA.

It is certainly tempting to suggest that the
path struct scheme would be better. The only
argument against it that I see is the kind
of changes you'd have to make to existing code.
It's not even a matter of having to make
changes, just which changes you make.


Casey Schaufler
casey@schaufler-ca.com
