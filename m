Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYLIWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYLIWzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYLIWzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:55:25 -0500
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:50818 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751073AbYLIWzY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:55:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DjKuG499u2wJmy0EqRUdrTNizthiPHIjqZTxK90QZ8wESOotqC9KOxgBT6b0qV5FPGkzgp5ddeSSoBwU/fYjuBGiWYr7T/V511G3Ni94qe3ejYyzRjxVdJocPuKCTFpU;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Fernando Luis =?iso-8859-15?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] PCI: remove pci_dac_dma_... APIs on mn10300
Date: Tue, 9 Dec 2008 14:55:01 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: akpm@linux-foundation.org, jbeulich@novell.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com
References: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812091455.01614.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 03, 2008 9:08 pm Fernando Luis Vázquez Cao wrote:
> It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
> cleanup work and still defines pci_dac_dma_supported(). This API is not
> required by the PCI subsystem anymore, so remove it.

Applied this to my linux-next branch, thanks.  I can drop it if the arch 
maintainer wants to send it instead though.

-- 
Jesse Barnes, Intel Open Source Technology Center
