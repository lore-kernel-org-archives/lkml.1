Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZATX2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZATX2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZATX2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:28:10 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48008 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbZATX2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:28:09 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB transfers
Date: Wed, 21 Jan 2009 00:28:38 +0100
User-Agent: KMail/1.9.10
Cc: David Miller <davem@davemloft.net>, ceggers@gmx.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <34115.192.168.0.40.1232483361.squirrel@server> <20090120.144719.120709836.davem@davemloft.net> <200901210017.19038.arnd@arndb.de>
In-Reply-To: <200901210017.19038.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901210028.41231.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 21 January 2009 00:17:18 schrieb Arnd Bergmann:
> > +       buffer = kmalloc(size, GFP_NOIO);
> 
> GFP_NOIO seems out of place in a network driver: there is nothing
> wrong with waiting for I/O here, so plain GFP_KERNEL should be fine.

What happens if you run nfs over that link?

	Regards
		Oliver

