Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYC0OOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYC0OOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYC0ONy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:13:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYC0ONx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:13:53 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [patch 0/7] vfs: mountinfo (v4)
To: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 27 Mar 2008 15:10:35 +0100
References: <abZpb-4D2-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JesoN-0000ta-Mo@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX186aYE//IRoyvssJyTXQhO5chxU2ehftH3zoO8
 taAEAQGTUxOKDtVcde8UTrRNEwgqcbB0a/2cwVMFbHBu8k+wpY
 VxKrpzKR5a7eCHFCkh1OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Another update that fixes Al's latest comments:
> 
>  - the per-sb options are merged into the fs-specific options
>  - mount source is shown as a separate field (because commas are not
>    escaped within it)
>  - group id checking before allocation/freeing: this one doesn't
>    actually make a difference for the moment (I hope) but Al's variant
>    is cleaner
>  - simplify ID allocation and freeing
>  - dominator renaming
>  - function header comment updating

Is it robust against mounting /dev/$'abc def\x0dghi'
to ~/mnt/`perl -e 'print "a" x 4050'`?

Besides that, I don't like having 'none' as the mount source. Instead, I
like to e.g. mount proc /proc -t proc, this will put the important
information into the first column of the mount(1) output, right where I
start reading.


