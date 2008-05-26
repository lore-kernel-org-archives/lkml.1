Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYEZMeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYEZMeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYEZM3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:29:33 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:55595 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbYEZM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:29:31 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: 2.6.26-rc3 - appletouch resume "incomplete data package"
Date: Mon, 26 May 2008 14:29:33 +0200
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
References: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
In-Reply-To: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805261429.34566.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 25 Mai 2008 22:24:13 schrieb Bob Copeland:
> This appears to be a regression since 2.6.25.  After resuming, I get:
> 
>     appletouch: incomplete data package (first byte: 2, length: 4).
>     appletouch: incomplete data package (first byte: 2, length: 4).
>     appletouch: incomplete data package (first byte: 2, length: 4).
>     [...]
> 
> And the touchpad doesn't work.  This is on a first gen MacBook.  I
> didn't see any changes to the driver itself in that timeframe.
> Anyone have ideas, or should I try a bisect?
> 

Can you add a RESET_RESUME quirk for the device?

	Regards
		Oliver

