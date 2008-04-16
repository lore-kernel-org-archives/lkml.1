Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbYDPRZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbYDPRZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYDPRYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:24:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYDPRYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:24:52 -0400
Subject: Re: [PATCH] Kconfig: enhance DEFAULT_MMAP_MIN_ADDR description
From: Eric Paris <eparis@redhat.com>
To: maximilian attems <max@stro.at>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Martin Michlmayr <tbm@cyrius.com>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
In-Reply-To: <1208366024-20261-1-git-send-email-max@stro.at>
References: <1208366024-20261-1-git-send-email-max@stro.at>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 13:23:09 -0400
Message-Id: <1208366589.12707.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-16 at 19:13 +0200, maximilian attems wrote:
> Got burned by setting the proposed default of 65536
> across all Debian archs.
> 
> Thus proposing to be more specific on which archs you may
> set this. Also propose a value for arm and friends that
> doesn't break sshd.

I certainly don't have a problem with the patch.

Acked-by: Eric Paris <eparis@redhat.com>

Although I do have reports of ppc64 and ia64 working fine with 64k I
don't see the need to clutter up the issue by listing all 3 arches I've
seen it not break instead of your message just mentioning x86.

-Eric

