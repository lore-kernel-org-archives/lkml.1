Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZGUPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZGUPsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbZGUPsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:48:39 -0400
Received: from iabervon.org ([66.92.72.58]:46569 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbZGUPsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:48:39 -0400
Date: Tue, 21 Jul 2009 11:48:37 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Pavel Machek <pavel@ucw.cz>
cc: apw@canonical.com, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch whitespace
In-Reply-To: <20090721100113.GC4133@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.0907211139400.2147@iabervon.org>
References: <20090721100113.GC4133@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Pavel Machek wrote:

> I don't think that a bit of trailing whitespace hurts that much (it is
> very easy to create when fixing overly long lines, another checkpatch
> complain), and at least akpm autofixes the whitespace, anyway, but...

The problem with trailing whitespace in files is that future developers 
have to keep it the same while making changes in the area, or it'll add 
noise to their commits and patches. Fixing up a patch to stop removing 
trailing whitespace is even more of a pain than fixing a patch to stop 
adding it.

> Would it be possible to add autofixing to checkpatch? Fixing
> whitespace issues by hand is useless & boring task...

Until checkpatch does it, "git apply" can be configured to auto-correct.

	-Daniel
*This .sig left intentionally blank*
