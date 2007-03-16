Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbXCPNi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbXCPNi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXCPNi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:38:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbXCPNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:38:27 -0400
Date: Fri, 16 Mar 2007 13:38:24 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 4/5] AF_RXRPC: Key facility changes for AF_RXRPC [try #2]
Message-ID: <20070316133824.GC2173@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, davem@davemloft.net,
	netdev@vger.kernel.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org
References: <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com> <20070316125031.3740.36610.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316125031.3740.36610.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 12:50:31PM +0000, David Howells wrote:
> Export the keyring key type definition.
> 
> Add extra alternative types into the key's type_data union to make it more
> useful.

You wrote the code so there must be some reason for this, but these
changes look rather odd to me :)

> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index ad45ce7..88292e3 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -66,6 +66,8 @@ struct key_type key_type_keyring = {
>  	.read		= keyring_read,
>  };
>  
> +EXPORT_SYMBOL(key_type_keyring);
> +

Having a type exported is really odd, how is this supposed to be a public API?
