Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYHRKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYHRKwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYHRKwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:52:23 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2569 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYHRKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:52:21 -0400
Message-ID: <17956.82.95.100.23.1219056651.squirrel@webmail.xs4all.nl>
Date: Mon, 18 Aug 2008 12:50:51 +0200 (CEST)
Subject: Re: scanner interface proposal was: [TALPA] Intro to a linux 
     interface for on access scanning
From: "Rob Meijer" <capibara@xs4all.nl>
To: david@lang.hm
Cc: "Casey Schaufler" <casey@schaufler-ca.com>,
       "Peter Dolding" <oiaohm@gmail.com>, rmeijer@xs4all.nl,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       "Eric Paris" <eparis@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Rik van Riel" <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
Reply-To: rmeijer@xs4all.nl
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 18, 2008 02:58, david@lang.hm wrote:
> since many people apparently missed this writeup I'm re-sending it.
>
> please try to seperate disagreement with the threat model this is
> addressing with disagreement with the design.

agreed.


> 3. (and the biggest batch) statements that this won't protect against
> problem X (where X was not in the threat model)
>
>    arguing againt this design is the wrong thing to do. argue against the
> threat model instead, preferrably by proposing a different threat model
> and allowing for a debate of which is appropriate.
>
> the threat model that was sent out (by others, not by me) basicly boils
> down to "don't allow programs to access/execute 'unscanned' data. don't
> try to defend against actions of programs already running or
> malicious user actions" there were further comments listing things it's
> not trying to cover.

I have multiple issues with this model:

1) It is basically the model used by black-list centric virus scanners.
   Recent demonstrations have shown how apparently easy it is to bypass
   blacklist technology, thus investing in providing hooks for technology
   that is arguably quickly becoming obsolete is IMO questionable.
2) Whitelisting, while a great partial solution is insufficient to become
   a solution all by itself. It does not lend itself to the single
   allow or kill approach above.
3) Most of the malware problem comes from the fact that software runs with
   all of the user her privileges while it could run with much less (least
   even) without (much) possibilities of doing malice.

The combination of these makes me come to the conclusion that a much more
viable alternative model would be:

"Don't allow (whitelist) unscanned programs to run with user privileges.
Allow unscanned and untrusted programs to run with (dynamic) least
authority. No blacklist scanning."

Rob


