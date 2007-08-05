Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbXHEMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbXHEMix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXHEMip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:38:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44669 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXHEMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:38:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Adrian Bunk <bunk@stusta.de>, Cedric Le Goater <clg@fr.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Andrew Morgan <agm@google.com>
Subject: Re: CLONE_NEWUSER documentation
References: <46B599C6.7040201@gmx.net>
Date: Sun, 05 Aug 2007 06:36:55 -0600
In-Reply-To: <46B599C6.7040201@gmx.net> (Michael Kerrisk's message of "Sun, 05
	Aug 2007 11:35:02 +0200")
Message-ID: <m1643ukviw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> writes:

> Hello Serge,
>
> In 2.6.23-rc, your patch to add support for CLONE_NEWUSER is included.  Is
> there there some for-userland-programmers documentation of this flag
> somewhere?  Would you be able to send some documentation to me (ideally as
> a patch to the clone.2 man page, but otherwise some plain text will do).
>
> If this flag is also supported for unshare(), then could you please send me
> a patch/text for that too?

Currently this namespace is a work in progress marked with CONFIG_EXPERIMENTAL
because it is very much still experimental and under development.

There may be other omissions but the one I am most aware of is that
the in kernel user and group equality comparisons have not become been
transformed from the form uid1 == uid2 to user_namespace1 == user_namespace2 &&
uid1 == uid2.

Until that happens that user namespace remains incomplete and not very
useful.  So the advice to users for now that unless they want to help
finish this up do not use.

Eric
