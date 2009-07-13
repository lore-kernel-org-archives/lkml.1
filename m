Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZGMNN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZGMNN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZGMNN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:13:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZGMNN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:13:27 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Vlasov <renton@renton.name>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Report file size for deleted files; was Re: Counters in df, du
References: <20090713081106.GA5569@beaver.vrungel.ru>
	<87fxd19cfq.fsf@basil.nowhere.org>
	<20090713113252.GB5569@beaver.vrungel.ru>
	<20090713115917.GA27684@basil.fritz.box>
X-Yow: WHO sees a BEACH BUNNY sobbing on a SHAG RUG?!
Date: Mon, 13 Jul 2009 15:13:09 +0200
In-Reply-To: <20090713115917.GA27684@basil.fritz.box> (Andi Kleen's message of
	"Mon, 13 Jul 2009 13:59:17 +0200")
Message-ID: <m3iqhwg1zu.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> But you can see the file date, these are new files and by next search
>
> I appended a patch that reports the size.

You can get the size already by using stat instead of lstat, ie. use ls -lL.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
