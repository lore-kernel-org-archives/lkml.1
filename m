Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXKJVEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXKJVEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXKJVEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:04:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbXKJVEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:04:42 -0500
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
From: Andi Kleen <andi@firstfloor.org>
References: <473380AD.5070801@crispincowan.com>
Date: Sat, 10 Nov 2007 22:04:35 +0100
In-Reply-To: <473380AD.5070801@crispincowan.com> (Crispin Cowan's message of "Thu\, 08 Nov 2007 13\:33\:33 -0800")
Message-ID: <p73tzntzuak.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan <crispin@crispincowan.com> writes:

The document should be a good base for a merge.

>     * A confined process can operate on a file descriptor passed to it
>       by an unconfined process, even if it manipulates a file not in the
>       confined process's profile. To block this attack, confine the
>       process that passed the file descriptor.

That is the only thing that tripped me up a bit while reading the document.
Can you expand a bit on the reasons why the fd is not rechecked in
the context of the target process? Best do it in a new version of the
document.

-Andi
