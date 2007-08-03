Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbXHCNxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbXHCNxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbXHCNw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:52:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:32432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731AbXHCNw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QJLRs9cQbdSct5LmADNYx+5VU4TTOHnR1S+ufL3qx5AcB8Qgcz7plzhkP1UGPVM4GssYuleK00XDqorJOkM6YJhqQrIXDg4vlN+/0r0buD6aCPULiU3uy12rLk8Gpxiozw0zdWimMu97Y7cY6+EVugHfTIKW0UWGyeNjh/crgus=
Message-ID: <cdc89fe60708030652p634c6ea1y1f7b351f12a35a7a@mail.gmail.com>
Date: Fri, 3 Aug 2007 08:52:58 -0500
From: "T. J. Brumfield" <enderandrew@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: about modularization
In-Reply-To: <cdc89fe60708030651s54b5f0e0j938450632cf621c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com>
	 <20070803131900.GA26203@elte.hu>
	 <cdc89fe60708030651s54b5f0e0j938450632cf621c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07, Ingo Molnar <mingo@elte.hu> wrote:
> snip...

Except that a working prototype of plugsched exists and functions
exactly as advertised.  I understand that modules can be loaded and
unloaded, where as other aspects of the core kernel can't just
load/unload as the kernel is running, but the cpu scheduler could be
selected at boot via a command line, or as a kconfig option when
compiling like the io scheduler.

And while the io team may feel that it would be best to have one
scheduler that worked well under all circumstances, often this can't
simply be the case.  Benchmarks over the years seem to suggest that
different schedulers work different for different situations.  In that
regard, choice does seem to be nice.

CFS is apparently better in its simplicity, however others are
reporting that SD still provides benefits for 3D gaming.  Perhaps
there are instances where even more schedulers like nicksched might be
the most appropriate solution.

-- T. J.
"In the beginning the Universe was created. This has made a lot of
people very angry and been widely regarded as a bad move."
--Douglas Adams
"Nihilism makes me smile."
--Christopher Quick
