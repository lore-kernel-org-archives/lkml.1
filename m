Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbXJWS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbXJWS4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXJWSz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:55:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:58927 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbXJWSz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fmef8BQIddT9bLCOmonV8Fz3JZrDsxlKQWYj9d0IXDobuylpugXrP+eDcARGkvqNwNTkM/83rsbTumf6+7VY2g3/40uACOaqcNVwMp/KxAZ2lguOipRaidPKPddVdQGRInB718Ti53Uyv/JdE00aFwKncOVUjc69J6aPNnfo9bk=
Message-ID: <9e0cf0bf0710231155n71cf38fey4d1edae6401db173@mail.gmail.com>
Date: Tue, 23 Oct 2007 20:55:54 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [BUG] rfcomm]
Cc: "Jiri Kosina" <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <1193164210.6184.221.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
	 <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
	 <1193163905.6184.214.camel@violet>
	 <9e0cf0bf0710231127o485a52e1sc7a06df7c8bc0189@mail.gmail.com>
	 <1193164210.6184.221.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> the code in net/bluetooth/rfcomm/tty.c contains two calls to
> device_move(). Please comment these out and try again. At least then we
> know that it is in issue on how we use the driver model.

No bugs...
Looks OK, although I don't know what removed :)

Regards,
Alon Bar-Lev.
