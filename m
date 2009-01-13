Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZAME2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZAME2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 23:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZAME2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 23:28:20 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:48603 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZAME2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hrK/BamjBY9ldJC06uoLUDlPvUp6Ck+UkleCG1dyiYinKpiiZ1z4ySVnJKa0mGgodF
         gcD8k2h7moIbbzQEujJEqmPIi1QmzaaepgcToRWktPtBhFGgPkYwmSaO8PEJ5fA20JLu
         6Y65oJVeLhjAVPE/YLN3I5X61qQ9i+zarYON0=
Message-ID: <b6a2187b0901122028w3f85fc9aj41d7c8ac44adb2ed@mail.gmail.com>
Date: Tue, 13 Jan 2009 12:28:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Daniel Drake" <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <alpine.LFD.2.00.0901121807070.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
	 <20090111162949.GA15338@elte.hu>
	 <200901111736.24350.borntraeger@de.ibm.com>
	 <20090111163904.GA21806@elte.hu>
	 <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
	 <20090111180714.GB15326@elte.hu>
	 <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
	 <alpine.LFD.2.00.0901121807070.6528@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 9:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
> that's a feature - the btrfs history looks like this. You can mark get out
> of that bisection set by doing this:

On Tue, Jan 13, 2009 at 10:08 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Is this a bug or a feature?
> You bisected into the btrfs development chain. Just say "git bisect good"
> when this happens, and you'll be ok.

Ingo, Linus,

Thanks for the explanation. For a while, I was repeating the same
thing just thinking my filesystem was corrupted.

Now, I'm can happily continue to bisect further.

Thanks,
Jeff.
