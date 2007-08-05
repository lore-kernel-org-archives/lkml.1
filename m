Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXHEMd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXHEMd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXHEMdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:33:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46774 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbXHEMdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:33:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Adrian Bunk <bunk@stusta.de>, Cedric Le Goater <clg@fr.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: CLONE_NEWUTS documentation
References: <46B599CA.9030302@gmx.net>
Date: Sun, 05 Aug 2007 06:27:29 -0600
In-Reply-To: <46B599CA.9030302@gmx.net> (Michael Kerrisk's message of "Sun, 05
	Aug 2007 11:35:06 +0200")
Message-ID: <m1abt6kvym.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> writes:

> Hello Serge,
>
> In 2.6.19, your patch to add support for CLONE_NEWUTS was included.  Is
> there there some for-userland-programmers documentation of this flag
> somewhere?  Would you be able to send some documentation to me (ideally as
> a patch to the clone.2 man page, but otherwise some plain text will do).
>
> If this flag is also supported for unshare(), then could you please send me
> a patch/text for that too?

Again a short summary

The utsname namespace encapsulates the global kernel identification stored
in struct utsname returned from uname(2).

It is a very trivial namespace but it allows you to set multiple hostnames
and nis domainnames on the same machine.

Eric
