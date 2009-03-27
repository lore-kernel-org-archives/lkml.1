Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZC0K1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZC0K1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZC0K11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:27:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43240 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751286AbZC0K11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:27:27 -0400
Date: Fri, 27 Mar 2009 10:28:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: davem@davemloft.net
Subject: Re: netrom: zero length frame filtering in NetRom
Message-ID: <20090327102823.3c485bfc@lxorguk.ukuu.org.uk>
In-Reply-To: <200903270102.n2R12S2U021576@hera.kernel.org>
References: <200903270102.n2R12S2U021576@hera.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	/* NetRom empty data frame has no meaning : ignore it */
> +	if (copied == 0) {
> +		goto out;
> +	}
> +

Also broken - and doesn't follow the coding style either 8)

I'm not familiar enough with ROSE to tell if the ROSE one is wrong, but
rose is X.25 LL based (sadly without the X.29 layer) so it seems odd
there too (especially for datagram services)


