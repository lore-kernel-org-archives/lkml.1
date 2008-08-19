Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYHSNSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYHSNSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYHSNSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:18:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYHSNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:18:32 -0400
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Robert Richter <robert.richter@amd.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
From: Andi Kleen <andi@firstfloor.org>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
	<48AA1E42.6070802@linux.intel.com>
	<19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com>
	<20080819094905.GA20590@elte.hu> <48AAB8B6.3020802@linux.intel.com>
	<87skt16u4a.fsf@skyscraper.fehenstaub.lan>
Date: Tue, 19 Aug 2008 15:18:25 +0200
In-Reply-To: <87skt16u4a.fsf@skyscraper.fehenstaub.lan> (Johannes Weiner's message of "Tue, 19 Aug 2008 14:56:37 +0200")
Message-ID: <87pro5ywgu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:
>
> You probably misconfigured emacs then.  I ran checkpatch over your patch
> and don't see how and why emacs would add trailing whitespace after a
> opening brace.

I don't know how, but it does. vim does too sometimes (I use both
editors) 

>
> You can use this to be on the safe side:
>
> (add-hook 'before-save-hook 'delete-trailing-whitespace)

That drops it on all. This means when I edit something which already
has trailing spaces then the diff is full of noise. That would
be a cure far worse than the disease[1]

Ideal would be if git-commit dropped them on all new lines, similar to 
git-apply --whitespace=fix and quilt refresh, but it doesn't seem to know how.

But normally maintainers just set these options (at least I do and Andrew
does too) so it doesn't really matter if the submitted patch has trailing 
spaces or not because they disappear on the way up. 

And that said I refuse to write any more on this silly bike shed topic.

-Andi

[1] to be honest I'm not sure i are actually a disease since I don't
know of any single problem they cause.
