Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbYEQSdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbYEQSdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYEQScz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:32:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:40367 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYEQScy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=fpo10Zpi3VHTvel1jK2N5p6lbssDWqFaSAAhmWr+RJJ403prtoL1uhrGxTo0d1bA0sjv9eXvi8x9QQiVZwSrgt23BjqcmMc+4FXmpqIIzrZMHkiLTkGtaKaRozoVwawNsMVOVbzbn6S50A7J5iW2VFeDbWRuQCEyLKNfhs39eQc=
Message-ID: <482F24C6.2050705@frugalware.org>
Date: Sat, 17 May 2008 20:32:38 +0200
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 onX61s laptop
References: <E1JxGth-0001te-S4@closure.thunk.org>  <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>  <20080517154131.GA7651@mit.edu>  <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com>
In-Reply-To: <1211047916.27447.314.camel@koto.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gabriel C <nix.or.die@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:

> On Sat, 2008-05-17 at 09:02 -0700, Pallipadi, Venkatesh wrote:
> 
>> I am thinking that may be X is depending on mprotect changes somehow and
>> failing when
>> it cannot change PAT attributes with mprotect call. Keith earlier
>> mentioned that X
>> will not depend on this. May be something to do with earlier X version.
>> Keith?
> 
> It looks like we can turn off read/write access, but we can't turn it
> back on. So,
> 
>         mprotect (map->memory, map->size, PROT_NONE);
>         mprotect (map->memory, map->size, PROT_READ|PROT_WRITE);
>  
> leaves the memory with no access.
> 
> Eric saw this last week; I don't know whether he debugged into it
> further.
> 
> Which repository is commit 1c12c4cf in?


It is in linus-git tree , http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c12c4cf9411eb130b245fa8d0fbbaf989477c7b


