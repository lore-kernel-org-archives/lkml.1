Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZE1M5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZE1M5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZE1M5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:57:34 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:52100 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZE1M5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:57:34 -0400
Date: Thu, 28 May 2009 05:55:38 -0700
From: "Larry H." <research@subreption.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090528125537.GD29711@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com> <20090528124840.GB1421@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528124840.GB1421@ucw.cz>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> This should not be configurable. Runtime config, defaulting to
> 'sanitize' may make some sense, but... better just be secure.

We've since moved to an unconditional page sanitization approach,
enabled via boot option. Check out the latest patches in the thread,
don't bother checking the initial page flag ones since there's no
intention to follow that path for now.

Thanks for taking a look.

	Larry

