Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZLZUBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZLZUBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 15:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZLZUBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 15:01:36 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:63494 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZLZUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 15:01:35 -0500
Date: Sat, 26 Dec 2009 15:01:31 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** Fixed in
 2.6.33-rc2 **
In-reply-to: <4B363EEE.8020108@blueyonder.co.uk>
Message-id: <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain>
References: <4B324B76.9020901@blueyonder.co.uk>
 <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk>
 <4B363EEE.8020108@blueyonder.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sid,
If the kernel boots properly as of -rc2, then I would not worry
so much that it was broken at some point during the merge window.

However, if it is still broken and you need to bisect back
into -merge to find out what caused it...  note that
booting with "acpi=ht" may be a useful tool.  For this
option will boot just enough of ACPI to enumerate processors,
but no more.  (Of course if this option doesn't boot with
the previous working kernels, then alas, it will not be useful here)

cheers,
Len Brown, Intel Open Source Technology Center

