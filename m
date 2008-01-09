Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbYAIGP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbYAIGP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYAIGPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:15:49 -0500
Received: from 1wt.eu ([62.212.114.60]:1237 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYAIGPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:15:48 -0500
Date: Wed, 9 Jan 2008 07:03:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Matthew Wilcox <matthew@wil.cx>,
       Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080109060324.GD19959@1wt.eu>
References: <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist> <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu> <20080107213717.GB16309@parisc-linux.org> <26581.1199747065@turing-police.cc.vt.edu> <20080107231930.GC16309@parisc-linux.org> <8336.1199851267@turing-police.cc.vt.edu> <20080108201042.03c3aead.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108201042.03c3aead.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 08:10:42PM -0800, Andrew Morton wrote:
[...]
> I must say that the number of bugs which actually go away when the user
> stops using nvidia/fglrx/ndiswrapper/etc is a small minority.

[...]
> But people who think that removing the nvidia driver will
> magically fix that khubd-got-stuck-in-D-state bug are urinating up an
> incline.
> 
> 
> Facts:
> 
> - lots of people use nvidia/etc
> 
> - most bugs they report aren't caused by nvidia/etc
> 
> - we need lots of testers
> 
> draw you own conclusions.

Thanks Andrew for this demonstration. At least now I know I'm not the only
one to think that. And no, I do not have any nvidia/etc. It's just that I
value their users' reports as much as the other ones just because otherwise
we would only track some elite's bugs, thus reducing the amount of information
we have to understand the circumstances under which it happens.

Cheers,
Willy

