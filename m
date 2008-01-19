Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbYASBpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbYASBpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYASBpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:45:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:58281 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbYASBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=w6Mz2RFrXB3Ms4h+JgCDftypJvMEMyxEydyNEiyhAdoxmZK1XwJERGzGgaTXjPJRoxQ6SDDqeFYLVfxOIvH8i6A8lpB1/eqL9/j+vETavWkYY5ZrlNWeq0NJ9fJKRFFG3qP93ZbJCzCrIfnIDo1fx1hXwHOR4LJ8quPEUT4oZQQ=
Message-ID: <47915614.7080608@gmail.com>
Date: Sat, 19 Jan 2008 10:44:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190727.36567.rusty@rustcorp.com.au> <47913261.5000708@gmail.com> <200801191228.30363.rusty@rustcorp.com.au> <47915515.1020905@gmail.com>
In-Reply-To: <47915515.1020905@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> so I think the question is "do we want to change all callbacks to
> take native pointer type instead of void pointer?".

Lemme clarity myself a bit.  I'm not saying that we should convert all
at once or literally every callback should be converted.  What I'm
saying is whether we're headed that way in general and converting big
ones - timer for example - and getting the conversion agreed upon should
be enough to set the norm.

Thanks.

-- 
tejun
