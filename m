Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZEAIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZEAIr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZEAIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 04:47:49 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:44740 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZEAIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 04:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L1cwgJKwF86cQ6onLgvu/OXelp9W7VN6AYmDbOZoU33XU1vrg+B6yCCCpmF6XFuDk+
         l3suxzh4WmPYXeYXYxaMXET4u7392cY0i6EvQWcPvCdAdyRKvcH0kLknYBC2iGvnya0r
         cEaWqWh0DINy7OsCifpgdBqXGVH/HpjpWbImY=
MIME-Version: 1.0
In-Reply-To: <20090430233642.333097165@goodmis.org>
References: <20090430233642.333097165@goodmis.org>
Date: Fri, 1 May 2009 09:47:45 +0100
Message-ID: <9b2b86520905010147l702e5129i1aa24c1eeefced27@mail.gmail.com>
Subject: Re: [PATCH 0/2] kconfig: updates to streamline_config.pl
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/09, Steven Rostedt <rostedt@goodmis.org> wrote:
> Thanks to Alan Jenkins for suggesting these cleanups/fixes/enhancements.

And thanks to you for pushing this script!  It should be handy for
speeding up bisection builds, without accidentally disabling a config
that caused the regression.

Though I'm wary of it for _general_ usage, because of hotplug.  I
think it would be even more useful if there was some way to preserve
all the currently selected USB drivers.

Alan
