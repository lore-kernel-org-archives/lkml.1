Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbXFEWjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbXFEWjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765692AbXFEWjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:39:42 -0400
Received: from ozlabs.org ([203.10.76.45]:48597 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765761AbXFEWjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:39:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18021.55632.359206.105260@cargo.ozlabs.ibm.com>
Date: Wed, 6 Jun 2007 07:44:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH TRIVIAL] icom whitespace cleanups
In-Reply-To: <4665D3EC.60404@redhat.com>
References: <4665D3EC.60404@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook writes:

> Clean up whitespace and comments in drivers/serial/icom.c

These changes seem totally unnecessary, as the existing indentation is
according to a commonly-accepted style and is quite reasonable:

> @@ -149,23 +149,23 @@ static void free_port_memory(struct icom
>  	trace(icom_port, "RET_PORT_MEM", 0);
>  	if (icom_port->recv_buf) {
>  		pci_free_consistent(dev, 4096, icom_port->recv_buf,
> -				    icom_port->recv_buf_pci);
> +			icom_port->recv_buf_pci);
>  		icom_port->recv_buf = NULL;
>  	}
>  	if (icom_port->xmit_buf) {
>  		pci_free_consistent(dev, 4096, icom_port->xmit_buf,
> -				    icom_port->xmit_buf_pci);
> +			icom_port->xmit_buf_pci);

etc. etc.  The comment changes I agree on but not most of the other
whitespace changes.

Also you don't seem to have cc'd the driver author.

Paul.
