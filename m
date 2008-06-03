Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYFCQmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYFCQmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYFCQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:42:12 -0400
Received: from saeurebad.de ([85.214.36.134]:51013 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYFCQmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:42:12 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH] add a printk_init variant storing format strings in __initdata
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	<1212485252.0@pinky>
Date: Tue, 03 Jun 2008 18:41:31 +0200
In-Reply-To: <1212485252.0@pinky> (Andy Whitcroft's message of "Tue, 3 Jun
	2008 10:27:32 +0100")
Message-ID: <87r6beh3no.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andy Whitcroft <apw@shadowen.org> writes:

> [As gcc seems unable to help us out selecting the appropriate data segment
> for the code, how about we did something like this?]
>
> When using printk from __init functions it would be desirable to place
> the printk format strings in __initdata.  Add a printk_init() variant
> which does this.

http://lkml.org/lkml/2008/2/4/185

I don't know if `desirable' is the technical argument Sam wants to hear :)

	Hannes
