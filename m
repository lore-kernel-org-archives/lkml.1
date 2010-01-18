Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340Ab0ARIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0ARIoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490Ab0ARIoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:44:20 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49386 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0ARIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:44:19 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2010 03:44:18 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZT3bx4QUEmhzoT2nRkhGnTE0xVjWM40HWjcaXx9H/tr5UdunXyZjtiyC+JK6n7CCtF
         0Ra6V+ITDJr9btCtzSV+ygkclulS8NR7LBZD+qGWU8z9HtXVTLfwbJn8cSTwaa/CZJJp
         9R4MT4ihQWYS8xKsNbffQl6pD0XTaI+jxS+FQ=
MIME-Version: 1.0
In-Reply-To: <20100118162412.9944c571.sfr@canb.auug.org.au>
References: <20100118162412.9944c571.sfr@canb.auug.org.au>
Date: Mon, 18 Jan 2010 09:36:29 +0100
Message-ID: <63386a3d1001180036h2bad24cas8c407edde729678e@mail.gmail.com>
Subject: Re: linux-next: trivial tree build failure
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/18 Stephen Rothwell <sfr@canb.auug.org.au>:

> Exposed by commit 8dcafdf0475eb4633401d1f0bf0e0d35e4ebb9d5
> "CONFIG_DEBUG_FS wrongly written as CONFIG_DEBUGFS".
> I have reverted that commit for today.

I have sent a proper patch to Sam last night, that fix the #ifdef and
makes the code work.

> That file probably just needs to include <linux/seq_file.h> ...

Not quite, there was some code rot in the #ifdef:ed code as well.

But it should all be fixed now!

Linus Walleij
