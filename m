Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZDGIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZDGIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZDGIXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:23:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:3497 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZDGIXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XIE09lsga+Mdx2NtYLxcUAohon7/LTtr33Fr5c2/AAK2CotbYaGJ+0s32aQivfiycF
         3Rk+pAUfqGVJGQFV43bFMCQvRunUEZfknBexHP+g91eKuc/z93ZdX706lOc9UUwNQjOM
         O6RGvb17/GBsidfRYTpJylhuswrcm+8PlADcU=
Date: Tue, 7 Apr 2009 17:23:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, perex@perex.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sound updates for 2.6.30
Message-ID: <20090407082312.GA10587@localhost.localdomain>
References: <s5hskkli38v.wl%tiwai@suse.de> <b6a2187b0904062304u609c6598i6d76a991b5ab0122@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0904062304u609c6598i6d76a991b5ab0122@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 02:04:28PM +0800, Jeff Chua wrote:
> I encountered this oops with the latest linux git pull. Will this
> update fix the problem? When I rolled back to 2.6.29-stable, the sound
> works find.

Yes, I got same oops and found the bug in ad1884_slave_vols table.
But I don't know why the oops doesn't happen with 2.6.29...
