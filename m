Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118Ab0A1W42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0A1W42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577Ab0A1W42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:56:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:52944 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0A1W41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OzniiB+E7yhkweRpfI93V+3D7wAyHcfcXNZYBzBB0wehZC9S4qs2xZTg04GFFj3PCQ
         SuHPXEIr1xWszeVKHZ19+O9N80xYARIgWv0G2WIcDznnE8A3oiNOZCtvPXc6XSYi0pIy
         oh7qtxeNIszMwLY7s6QfUTr/RsZqRU9BHyW9I=
Date: Thu, 28 Jan 2010 23:56:21 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
Message-ID: <20100128225621.GD3109@del.dom.local>
References: <4B60707F.1000608@majjas.com>
 <20100127095614.14313677@nehalam>
 <4B608128.7090607@majjas.com>
 <4B6089C7.4010803@majjas.com>
 <4B61ADF1.7060705@majjas.com>
 <4B61BEA4.1030905@majjas.com>
 <20100128090835.0d93e53a@nehalam>
 <4B61DB79.4080703@majjas.com>
 <20100128223447.GC3109@del.dom.local>
 <4B621316.8070308@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B621316.8070308@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 05:43:34PM -0500, Michael Breuer wrote:
> This is with the pci_unmap_len patch as well as the dma-debug patch.
> I'm not getting any warnings - but dma-debug num-free-entries drops
> until zero and then debugging is disabled. I started with 8,000,000
> about three hours ago - without load I'm already down to less than
> half that. Again - only looking at sky2. Looks like the dma-debug
> hash table is reducing one entry for every packet, but never
> increasing the num_entries (no unmap perhaps).

OK, then, until there is some new fix you better turn it off.

Jarek P.
