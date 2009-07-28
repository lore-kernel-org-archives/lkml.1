Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZG1GIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZG1GIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 02:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZG1GIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 02:08:49 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:42134 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZG1GIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 02:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qhe4CN+Q2p/IVs7wJqkmR/nqYP7eFIqtHcXTDKVMoFoUn3Agdsaolskpxyhohsv+Or
         USuDePLC146M6SMfQM7zPzOXHBlFgvalA58A3PXH4V/wBxHh1TwjuWCYsP2zmo6oiYWO
         xJODn7SeS71EE+tfNqf852FyB8uDF5Rxo30BU=
MIME-Version: 1.0
In-Reply-To: <20090727172542.GA5104@blimp.localdomain>
References: <20090727172542.GA5104@blimp.localdomain>
Date: Tue, 28 Jul 2009 08:08:47 +0200
Message-ID: <81b0412b0907272308w3b655e2ej37242a4d307e8174@mail.gmail.com>
Subject: Re: [PATCH] inotify: fix the running away counter of user watches
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: fs_other@kernel-bugs.osdl.org, Russell Bell <russellbell@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, josef@redhat.com,
       Eric Paris <eparis@redhat.com>, Robert Love <rlove@rlove.org>,
       John McCutchan <john@johnmccutchan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 19:25, Alex Riesen<raa.lkml@gmail.com> wrote:
> Sorry for long Cc:, I'm a little confused about "fs_other@" (and the
> list of participants) in the bug report.

Dumb me. Should have looked at Erics branch first (which _was_ hard to do,
infradead.org been that busy).

For reference: fixed in mainline 5549f7cdf84c02939fd368d0842aa2f472bb6e98
