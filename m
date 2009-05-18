Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZERRTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZERRTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZERRSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:18:54 -0400
Received: from khc.piap.pl ([195.187.100.11]:40879 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZERRSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:18:53 -0400
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to pr_notice(
References: <cover.1242609803.git.joe@perches.com>
	<4A11343C.5070809@ru.mvista.com> <m3skj2im12.fsf@intrepid.localdomain>
	<200905181550.07723.bzolnier@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 18 May 2009 19:18:52 +0200
In-Reply-To: <200905181550.07723.bzolnier@gmail.com> (Bartlomiej Zolnierkiewicz's message of "Mon\, 18 May 2009 15\:50\:07 +0200")
Message-ID: <m3octqib2b.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

>> Though I think most people would agree that the latter is much better,
>> no?
>
> No, it just hides the real issue:

I didn't say it's best. Just better :-)

>> I think removal (rewording) of this rule has already been agreed upon,
>> though not exactly yet codified.
>
> This is not a strict rule but in 99% cases it shows that the code could
> be improved further without >80 chars lines.

I don't have the stat numbers handy but the established idea is that
since the texts could be up to 80-chars long (and it's a good thing),
the printk line needed to output them has to be longer.
IOW, breaking the text into pieces is worse. Obviously, that doesn't
mean one can't do better.
-- 
Krzysztof Halasa
