Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYABTJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYABTJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYABTJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:09:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:7663 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYABTJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:09:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QzhBoLxzlndJnm20Eap+k9+JSL0H7KLfBbLhCsiPIAWJSy+cYF3ofltiv3/TBoKXMIqhOcpS21GsA9DjqgqYg3kfqBVwsWAqBii0RS7AzEqVbdnR4cCs+daH3pByJRl8mqDuHp0sKrX4jb1JZvMyPSfO3eDpe6aN6e2B7TO2lLs=
Message-ID: <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
Date: Wed, 2 Jan 2008 21:09:20 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
X-Google-Sender-Auth: 53dc16b54819091d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 2, 2008 8:43 PM, Hugh Dickins <hugh@veritas.com> wrote:
> SLUB's new slabinfo isn't there: it looks as if a last minute change
> to Pekka's patch left it dependent on CONFIG_SLAB at the procfs end:
> allow for CONFIG_SLUB too.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> To minimize ifdeffery, this leaves it with S_IWUSR though unwritable:
> I'm assuming that's acceptable.

I already sent the remaining bits to Linus but this looks much
cleaner. Thanks Hugh!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
