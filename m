Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZDOCRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZDOCRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZDOCRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:17:30 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:38657 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZDOCR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G8v4ogs+AAdvcv/Lgq0dnYPdai8ftwUOhB5cjuLLo2kkLXIaEntVrGpA4UaspA1m3k
         VS1qgR9nYx1SCMPiRKoJ/VjRr9QOokUQzC2FKDGXTa0Nf5Q4wwSSo467ZCVCxoi4R1Ql
         UtYxcUgpBH46ATlakfr/phR3ZD/f0ggtfF8DE=
MIME-Version: 1.0
In-Reply-To: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
Date: Tue, 14 Apr 2009 22:17:28 -0400
Message-ID: <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: introduce %pf
From: Mike Frysinger <vapier.adi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 20:00, Frederic Weisbecker wrote:
> - * - 'F' For symbolic function descriptor pointers
> + * - 'F' For symbolic function descriptor pointers with asm offset
> + * - 'f' For simple function symbol

"asm" is weird here as it isnt an assembly offset (not that i have any
idea what an "assembly offset" even means).  just say "offset".
-mike
