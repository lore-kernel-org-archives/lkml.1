Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYAIWgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYAIWgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYAIWf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:35:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:1242 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYAIWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QFuWIBvhhh7Hg7/Kgsdu9QF3aKEQkXgX70w4mHCifU323dKmvpcCm4J2d9wNRCxYHhn6x6oPv+Jn3fIeQ/KrCv2gb8AsqsfrytaH3YZbln+UkfsLgRwrr+vexbPmZr8+8l+ejclI+vO104szYZZz0EiKfC7cPoHttkKlzWDHdzM=
Subject: Re: More breakage in native_rdtsc out of line in git-x86
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080109222804.GF15612@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org>
	 <20080109090956.GA14274@elte.hu>
	 <20080109141908.GB12855@one.firstfloor.org>
	 <20080109152208.GA21280@elte.hu>
	 <20080109155124.GB12923@one.firstfloor.org>
	 <20080109163017.GG17739@elte.hu>
	 <20080109174800.GA15346@one.firstfloor.org>
	 <20080109220948.GA2218@atjola.homenet>
	 <20080109222804.GF15612@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 14:35:55 -0800
Message-Id: <1199918155.6424.71.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 23:28 +0100, Andi Kleen wrote:

> Do you have a simple recipe to just update from the the remote branch,
> assuming there are no local changes or local branches? 
> 
> -Andi

For staying up to date I use the following:

# Add Linus's tree as a remote
git remote --add linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# Add Ingo's tree as a remote
git remote --add x86
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

# With that setup, just run the following to get any changes you
# don't have.  It will also notice any new branches Ingo/Linus
# add to their repo.  Look in .git/config afterwards, the format
# to add new remotes is easy to figure out.
git remote update


Cheers,

Harvey

