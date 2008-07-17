Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbYGQTM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbYGQTM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbYGQTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:12:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:62742 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbYGQTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=obnIrH1QfZ6577R/u8+XFa3Y1J3NWAnpHs8NPd5xG61ZfTTBaBSrUMSFAf6salu893
         tS1c0RqQtQ6YzsJaI1nSvytwWUZPK8nMQEv/eYVpUxElkbOaifnBnTwSz/46YfRB1uH+
         gYx2jFbpGPewKX2k16krsKUeU+1DyajQeYkdc=
Subject: Re: Please pull ACPI updates
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain>
References: <20080716214516.GA10777@basil.nowhere.org>
	 <200807170011.12184.rjw@sisk.pl>
	 <200807161633.01375.jbarnes@virtuousgeek.org>
	 <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org>
	 <487EE940.1050007@firstfloor.org>
	 <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 12:12:11 -0700
Message-Id: <1216321931.6029.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 14:49 -0400, Len Brown wrote:
> Andi, Jesse, Linus,
> 
> One thing I wish I had in git is a way to make this sequence easier...
> 
> Say I have a big topic branch with 30 patches in it.
> The 3rd patch turns out to have a bug in it, but the
> rest of the series is okay.  Today I invoke gitk on
> the branch and keep that open.
> Then I create a new topic branch at the broken patch.
> 
> I always consult ~/src/git/Documentation/git-reset.txt
> so I can remember the following sequence...
> 
> $ git reset --soft HEAD^
> $ edit
> $ git commit -a -c ORIG_HEAD
> 
> Now I've got the fixed 3rd patch checked in,
> but 27 patches in the original branch are hanging
> off the original broken 3rd patch.
> So I git-cherry-pick 27 patches
> I hope I get them in the right order and don't miss any...
> 
> It would be nice if we could somehow git rebase those
> 27 patches in a single command, but if we do,
> that pulls with it the broken 3rd patch.

git rebase --interactive

sounds like exactly what you are asking for.

Harvey

