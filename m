Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZDOP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZDOP3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZDOP3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:29:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55554 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDOP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wUumC6q0QvEX4mLJRN3tGXmZbB/bR57FlOny1+Ogabi0CiP8Ls45dcGfcWNk933ru6
         O+rkobWxQDPGfq0hQclWOlWu5+4BGgOmhw4Tti5r9axVmJP3rIREx6RlBTIPH6rbuVB4
         44Q0e3gAt0N+jKhdpZzdtB+FKsHm8nEnERID8=
Date: Wed, 15 Apr 2009 17:29:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: introduce %pf
Message-ID: <20090415152924.GB5989@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:17:28PM -0400, Mike Frysinger wrote:
> On Tue, Apr 14, 2009 at 20:00, Frederic Weisbecker wrote:
> > - * - 'F' For symbolic function descriptor pointers
> > + * - 'F' For symbolic function descriptor pointers with asm offset
> > + * - 'f' For simple function symbol
> 
> "asm" is weird here as it isnt an assembly offset (not that i have any
> idea what an "assembly offset" even means).  just say "offset".
> -mike


Right, "asm" offset made sense for me because
I've kept %pF offset output and gdb disass output on the same
area in my brain :-)

I will update the patch with just "offset", thanks!

