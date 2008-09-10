Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYIJWo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYIJWo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYIJWoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:44:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:44270 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYIJWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:44:16 -0400
Message-ID: <f488382f0809101544o5aa9d9d1scdf64a1d0b004d07@mail.gmail.com>
Date: Wed, 10 Sep 2008 15:44:15 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <87myifmxpk.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
	 <200809102309.34159.bzolnier@gmail.com>
	 <f488382f0809101419y65b35547t572a0f7bb5316952@mail.gmail.com>
	 <87myifmxpk.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 3:40 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
>
> What about changing the declaration to
>
>        int i, uninitialized_var(rc);
>
> then?
>

That's probably a -much- better idea. I'm an utter newbie to kernel
development, so I wasn't aware of that feature.

- Steven
