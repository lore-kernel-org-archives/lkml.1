Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0BATfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:35:33 -0500
Received: from mail.perches.com ([173.55.12.10]:1713 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab0BATfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:35:32 -0500
Subject: [RFC] Fix unnecessary spaces before newlines in logging messages
From: Joe Perches <joe@perches.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201002012007.25498.elendil@planet.nl>
References: <cover.1264967493.git.joe@perches.com>
	 <cover.1264967493.git.joe@perches.com>
	 <m2n.s.201002011906064544@fjphome.nl>
	 <201002012007.25498.elendil@planet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 11:35:29 -0800
Message-ID: <1265052929.25140.331.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 20:07 +0100, Frans Pop wrote:
> Would it be an idea to also get rid of all the trailing spaces in printks?
> 
> If you'd prefer a separate patch, I can do it.

(cc:s trimmed)

I think it's useful, though like all of these cleanups,
a low priority.  I suggest you submit a few through to
various maintainers and see what happens.

(with false positives for asm and such)
$ grep -rP --include=*.[ch] "\s+\\\n" * | wc -l
7339

There are probably a couple of thousand wasted bytes in
an allyesconfig image and rather more in various logs on
any number of systems.


