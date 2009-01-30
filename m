Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZA3GQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZA3GQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZA3GQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:16:48 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41964 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZA3GQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:16:47 -0500
Date: Fri, 30 Jan 2009 07:16:46 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
In-Reply-To: <1233294584.28741.2.camel@localhost>
Message-ID: <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
References: <1233294584.28741.2.camel@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-01-30 06:49, Nathanael Hoyle wrote:
>
>I have done a bit of research on how the kernel scheduler works, and
>why I am seeing this behavior. I had previously, apparently
>ignorantly, equated 'nice 19' with being akin to Microsoft Windows'
>'idle' thread priority, and assumed it would never steal CPU cycles
>from a process with a higher(lower, depending on nomenclature)
>priority. [...]
>
>One[...] is to alter the semantics of nice 19 such that it does not
>boost. Since this would break existing assumptions and code, I do
>not think it is feasible. [...] Finally, new scheduling classes
>could be introduced[...]

Surprise. There is already SCHED_BATCH (intended for computing tasks
as I gathered) and SCHED_IDLE (for idle stuff).



>Please make the obvious substitution to my email address in order to 
>bypass the spam-killer.

(Obviously this is not obvious... there are no 'nospam' keywords or 
similar in it that could be removed.)
