Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbZLDXQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbZLDXQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbZLDXQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:16:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:45511 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbZLDXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:16:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vukA/FrZyAQcQLq4Oq6soG9L1y6De8Ph/81LLzeCHN1tmeB7fBOAGAeGbcFuA/1Z+d
         6nsOWA+nEth1yPhoJITzbJjjdIg8BL+VfCTbHdLX9F5DDHb3VkKQlHlNPTkFIZYcNHcC
         QymoaRRjbADTji9bNneVfrmWURUAPm1D6oXLI=
Date: Sat, 5 Dec 2009 02:16:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, andre.goddard@gmail.com
Subject: Re: + ctype-constify-read-only-_ctype-string.patch added to -mm
 tree
Message-ID: <20091204231616.GB16465@x200>
References: <200912042232.nB4MW8ZI011462@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912042232.nB4MW8ZI011462@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 02:32:08PM -0800, akpm@linux-foundation.org wrote:
> While at it, use tabs to indent the comments.

Can you just add const and not do reformatting because, you know,
it's still not perfect.

> -extern unsigned char _ctype[];
> +extern const unsigned char _ctype[];
