Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbYLWS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbYLWS4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 13:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLWS4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 13:56:08 -0500
Received: from www.tglx.de ([62.245.132.106]:49980 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYLWS4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 13:56:07 -0500
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
	<20081223115428.GB1439@ucw.cz>
Date: Tue, 23 Dec 2008 19:55:27 +0100
In-Reply-To: <20081223115428.GB1439@ucw.cz> (Pavel Machek's message of "Tue\, 23 Dec 2008 12\:54\:28 +0100")
Message-ID: <864p0u202o.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-12-23, Pavel Machek <pavel@suse.cz> wrote:
>> MOTIVATION
>> 
>> Since 2001 various anti-virus vendors have been providing
>> out-of-tree solutions for online virus scanning. Although GNU/Linux
>> systems currently are not targets of virus authors, many
>> organizations are interested in online virus scanning on
>> Linux-based servers in order to help protect Microsoft Windows
>> clients. It is often argued that file scanning should be
>> implemented in the various services (such as Samba, Apache, vsftpd,
>> etc.), and indeed many such solutions have been
>> implemented. However, there is a continued demand for a
>> kernel-based solution because it can guard the entire filesystem
>> independent from the types and numbers of services running on a
>> system.
>
> Somewhere here you should mention that unlike other solutions that
> work 100% of time, dazuko is be design racy and may still allow
> viruses to be spread from linux system when mmap is used.

This thread is about DazukoFS. I feel there is no need to discuss
previous incarnations of Dazuko, all of which share _no_ code with
DazukoFS.

If you are aware of a race condition in DazukoFS, please report
it. Thank you.

John Ogness
