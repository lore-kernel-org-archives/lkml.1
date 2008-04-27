Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbYD0Tyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbYD0Tyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763325AbYD0TyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:54:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:25372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761900AbYD0TyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ZxSTrNkEFt5o5Ogx7ZEzzhNFmsPhnM0JEO1yGtSJHQRHVn1mQQJOmfUdP1nX4eeu1N4TRXij1oJU4f+YBWgieQMqeDI4hW6ETjTs8Jzi+P/j/m+JGQ4EbRjOYFQ37UGoZA277XT6I6u4th5z+tPX05I/nnOb5ogokaFTn+96oAk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
Date: Sun, 27 Apr 2008 20:32:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Borislav Petkov <petkovbb@gmail.com>
References: <48055F1A.9020706@tiscali.nl>
In-Reply-To: <48055F1A.9020706@tiscali.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804272032.47939.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Roel Kluin wrote:
> Is this the right fix in this case?
> ---
> valid is unsigned and cannot be below 0.,
>     
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

applied
