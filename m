Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbYBTK5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbYBTK5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYBTK5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:57:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46391 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYBTK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:57:10 -0500
Date: Wed, 20 Feb 2008 11:57:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Theodore Tso <tytso@mit.edu>
cc: Andi Kleen <andi@firstfloor.org>, Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
In-Reply-To: <20080218153501.GE25098@mit.edu>
Message-ID: <Pine.LNX.4.64.0802201156520.26109@fbirervta.pbzchgretzou.qr>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de>
 <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org>
 <20080218151632.GD25098@mit.edu> <20080218155725.GB26622@one.firstfloor.org>
 <20080218153501.GE25098@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18 2008 10:35, Theodore Tso wrote:
>On Mon, Feb 18, 2008 at 04:57:25PM +0100, Andi Kleen wrote:
>> > Use cp
>> > or a tar pipeline to move the files.
>> 
>> Are you sure cp handles hardlinks correctly? I know tar does,
>> but I have my doubts about cp.
>
>I *think* GNU cp does the right thing with --preserve=links.  I'm not
>100% sure, though --- like you, probably, I always use tar for moving
>or copying directory hierarchies.

But GNU tar does not handle acls and xattrs. So back to rsync/cp/mv.
