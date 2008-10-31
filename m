Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYJaPDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYJaPDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYJaPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:03:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:7500 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYJaPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=XdnRZ/Hg2h//uyV6Ht0xiz5SWq2YX5WGLKi715F1SHvMu2ZeOIPkNnGQsoKHTn9MCX
         fqIWeZXevJFX9jWK0Srv+7cxnKSCYbUjjF58QbtKWjzX129K/PUKr7xgANmZSnIYTiAq
         vQszj7ItJKlSA4UnqTMubu4Emxi7r5rNrqtFs=
Date: Fri, 31 Oct 2008 16:02:48 +0100
From: Kai Henningsen <kai.extern@googlemail.com>
To: mtk.manpages@gmail.com
Cc: mtk.manpages@googlemail.com, "Daniel Gollub" <dgollub@suse.de>,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-man@vger.kernel.org, ltp-list@lists.sourceforge.net,
       "A.E. Brouwer" <aeb@win.tue.nl>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Message-ID: <20081031160248.2b95d0e8@desktop.khms.westfalen.de>
In-Reply-To: <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
References: <20081023145054.998439866@marvin.suse.de>
	<cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
Organization: Organization?! Me?!
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 24 Oct 2008 17:53:25 -0500
schrieb "Michael Kerrisk" <mtk.manpages@googlemail.com>:

> Hi Daniel,
> 
> On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub@suse.de>
> wrote:

> > EINVAL bufsiz is not positive.

> The EINVAL error was added to man-pages-1.18 in 1997 (even though, as
> you note, the type was "size_t").  I suspect (this was well before I
> had any association with man-pages) that was done to reflect kernel
> reality (since one could bypass glibc invoke the syscall directly),
> but obviously it is inconsistent with the prototype.

Actually, it's not inconsistent as described, though perhaps that is
unintentional. "Not positive" isn't the same as "negative", as zero
isn't positive either, and zero is certainly a possible value of an
unsigned type
