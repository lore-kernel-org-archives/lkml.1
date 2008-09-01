Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbYIAXMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbYIAXMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYIAXMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:12:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:46448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYIAXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vpNYEXFowfEYxbiMdmYy1caHbeTNefK6PYLlAc+2gBO9rDU/4rmkuz9RVgwwc0TO5j
         V+oSy7N+cYOonlib/uToHha6EG02NoEho1R/5StpkJuZ20iyRd0G8BwqWQFnRXzdE5Mf
         bkerp4uMjv3Rta13Jr7TuLluxSbhdP0AdNgFU=
Date: Tue, 2 Sep 2008 03:14:19 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org
Subject: Re: [path] don't diff generated firmware files
Message-ID: <20080901231419.GA5602@x200.localdomain>
References: <20080901150951.5cba4dc7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901150951.5cba4dc7@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 03:09:51PM -0700, Arjan van de Ven wrote:
> With the new firmware infrastructure in 2.6.27, some files are generated and shouldn't be
> diffed; add these 2 to the "dontdiff" file

> --- linux.trees.git/Documentation/dontdiff
> +++ linux.trees.git/Documentation/dontdiff
> @@ -5,6 +5,8 @@
>  *.css
>  *.dvi
>  *.eps
> +*.fw.gen.S
> +*.fw

Dontdiff is obsoleted because of .gitignore and should probably be auto-generated
from them.

