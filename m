Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZEYOB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZEYOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZEYOBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:01:51 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:63481 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbZEYOBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:01:50 -0400
Date: Mon, 25 May 2009 16:01:51 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       tytso@thunk.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Message-ID: <20090525140151.GE5534@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <20090524101551.57b706e9@infradead.org> <20090524173933.GD24753@cip.informatik.uni-erlangen.de> <20090525120320.GA25908@mit.edu> <20090525123430.GA5534@cip.informatik.uni-erlangen.de> <87ab51qq91.fsf@frosties.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ab51qq91.fsf@frosties.localdomain>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Goswin,

> I could imagine a device mapper target that eats TRIM commands and
> writes out zeroes instead. That should be easy to maintain outside or
> inside the upstream kernel source.

again an interesting option and for sure easy to handle. However what
I'm really looking for is an option that gets upstream and will be
incorperated in major distributions so that this option is available on
every Linux distribution shipping in two years. However if this won't be
the case I'm going to consider writing a device mapper target.

        Thomas
