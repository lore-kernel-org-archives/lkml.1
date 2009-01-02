Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZABRZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZABRZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbZABRZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:25:29 -0500
Received: from postmen.rb009.by.ded.neolocation.net ([91.149.189.39]:53437
	"EHLO postmen.neolocation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757029AbZABRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:25:29 -0500
X-Greylist: delayed 2224 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 12:25:28 EST
Date: Fri, 2 Jan 2009 18:45:22 +0200
From: Sergei Trofimovich <slyfox@uvaga.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i8k: Add Dell Vostro systems
Message-ID: <20090102184522.07bc2b86@slyfox.slynet.org>
In-Reply-To: <20090102161919.18117.51612.stgit@localhost.localdomain>
References: <20090102161825.18117.98501.stgit@localhost.localdomain>
	<20090102161919.18117.51612.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
DomainKey-Status: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jan 2009 16:19:23 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

Hi! I bet, it does not pass checkpatch (tabs to spaces clash)
Sorry, can't send fixed patch.

> From: Federico Heinz <fheinz@vialibre.org.ar>
> 
> This trivial patch adds support for i8k on the new Dell Vostro models.
> I tested it on my Vostro 1400, and it works. It does print a warning
> when loading the module:
> 
> 	i8k: unable to get SMM BIOS version
> 
> But I couldn't figure out how to fix that. The module seems to work fine,
> anyway...
> 
> Signed-off-by: Federico Heinz <fheinz@vialibre.org.ar>
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/char/i8k.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 099fc89..fc8cf7a 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c

...
> -	{ }
^^^^^^
This one
vvvvvvv
> +        { }
>  };

-- 

  Sergei
