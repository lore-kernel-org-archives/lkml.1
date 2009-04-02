Return-Path: <linux-kernel-owner+w=401wt.eu-S1764007AbZDBQ1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764007AbZDBQ1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZDBQ10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:27:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57932 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753865AbZDBQ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:27:25 -0400
Date: Fri, 3 Apr 2009 00:06:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Patrick Mullaney <pmullaney@novell.com>, anthony@codemonkey.ws,
       andi@firstfloor.org, Peter Morreale <PMorreale@novell.com>,
       rusty@rustcorp.com.au, agraf@suse.de, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402160625.GA2173@gondor.apana.org.au>
References: <49D469D2020000A100045FA1@lucius.provo.novell.com> <49D473EA020000C700056627@lucius.provo.novell.com> <49D473EA020000C700056627@lucius.provo.novell.com> <49D4CB38.5030205@redhat.com> <49D4DA54.3090401@novell.com> <49D4DE82.5020306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4DE82.5020306@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 06:49:22PM +0300, Avi Kivity wrote:
>
> I still think you want one MSI per device rather than one MSI per vbus,  
> to avoid scaling problems on large guest.  After Herbert's let loose on  
> the code, one MSI per queue.

Yes, one MSI per TX queue, and one per RX queue :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
