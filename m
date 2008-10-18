Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbYJRL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbYJRL5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYJRL5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 07:57:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJRL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 07:57:14 -0400
Date: Sat, 18 Oct 2008 07:57:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wolfgang Kroworsch <wolfgang@kroworsch.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] vt: incomplete initialization of vc_tab_stop
Message-ID: <20081018115712.GA16600@infradead.org>
References: <20081018114929.GA25554@kroworsch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018114929.GA25554@kroworsch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 01:49:31PM +0200, Wolfgang Kroworsch wrote:
>  	vc->vc_tab_stop[1]	=
>  	vc->vc_tab_stop[2]	=
>  	vc->vc_tab_stop[3]	=
> -	vc->vc_tab_stop[4]	= 0x01010101;
> +	vc->vc_tab_stop[4]	=
> +	vc->vc_tab_stop[5]	=
> +	vc->vc_tab_stop[6]	=
> +	vc->vc_tab_stop[7]	= 0x01010101;
>  
> +					vc->vc_tab_stop[4] =
> +					vc->vc_tab_stop[5] =
> +					vc->vc_tab_stop[6] =
> +					vc->vc_tab_stop[7] = 0;

Using memset might be a beter idea.

