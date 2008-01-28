Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYA1RyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYA1RyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYA1RyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:54:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:27473 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYA1RyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:54:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=KSRmXFQTWQMHYYV9QhjE8QDZvaa/7jJ+bW8u62du0hVZd7cZW67oUlj9pzu/S+4wRcSna/IH354gGXNoxRLU2w88YkgTjre8ACVhqXFo3bQWAp03Jp6DC3rDMYjw5fTMqmnHrDzBXLhCNi2INDFjTSQ8XwyTjwh3/8PxJR33WnU=
Date: Mon, 28 Jan 2008 20:53:57 +0300
To: David Sterba <dsterba@suse.cz>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-ID: <20080128175357.GA1990@martell.zuzino.mipt.ru>
References: <20080128171929.GA3906@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128171929.GA3906@ds.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 06:19:29PM +0100, David Sterba wrote:
> ipwireless: driver for PC Card, 3G internet connection

> +struct nl_first_paket_header {
> +#if defined(__BIG_ENDIAN)
> +	unsigned char packet_rank:2;
> +	unsigned char address:3;
> +	unsigned char protocol:3;
> +#else
> +	unsigned char protocol:3;
> +	unsigned char address:3;
> +	unsigned char packet_rank:2;
> +#endif
> +	unsigned char length_lsb;
> +	unsigned char length_msb;
> +};
> +
> +struct nl_packet_header {
> +#if defined(__BIG_ENDIAN)
> +	unsigned char packet_rank:2;
> +	unsigned char address:3;
> +	unsigned char protocol:3;
> +#else
> +	unsigned char protocol:3;
> +	unsigned char address:3;
> +	unsigned char packet_rank:2;
> +#endif
> +};

You want __BIG_ENDIAN_BITFIELD here.
