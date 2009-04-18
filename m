Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZDRHil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZDRHil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZDRHic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:38:32 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33637 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDRHic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:38:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Peter Holik" <peter@holik.at>
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
Date: Sat, 18 Apr 2009 09:38:47 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at> <200904171641.33546.oliver@neukum.org> <8472e581ef388a89b5ee8a7ed8dd1fdc.squirrel@webmail.it-technology.at>
In-Reply-To: <8472e581ef388a89b5ee8a7ed8dd1fdc.squirrel@webmail.it-technology.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904180938.48276.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 18 April 2009 09:16:28 schrieb Peter Holik:

> > +       len = (skb->data[skb->len - 2] | (skb->data[skb->len - 1] << 8));
> >
> > Please use a conversion function.
>
> do you mean
>
> len = le16_to_cpu(skb->data[skb->len - 2] | (skb->data[skb->len - 1] <<
> 8));

Without the "|". Just dereference the pointer.

>   pack_len &= 0x07ff;
>
>   len = (__le16 *) __skb_push(skb, INT51X1_HEADER_SIZE);
>   *len = cpu_to_le16(pack_len);

That's correct.

	Regards
		Oliver

