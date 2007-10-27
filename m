Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXJ0SwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXJ0SwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXJ0SwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:52:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:55224 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXJ0SwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tGOGsS9qZzmaisrQhT67ffQC9Vp5hyDpZgv3V688mm/BJPHmfhTJnEEXatmglQ2kteB5bgJXhDFRFjaocDNkom5GsnQH0LOj2C2mOSy7gVUbZtu4KcKmfY4IotUZDAAzBsd6k5MSmZqmu4MYJzVvdjDaW+Gzjk08aOvX6dhBc7U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ide/arm/icside: fallout from commit 86f3a492bb09eee5745b93af35f2212179c251fd
Date: Sat, 27 Oct 2007 20:58:37 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <20071027183923.GO8181@ftp.linux.org.uk>
In-Reply-To: <20071027183923.GO8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710272058.38211.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007, Al Viro wrote:
> struct device doesn't have ->dma; it's in struct expansion_card where
> that struct device is embedded into.

Yeah, your fix is obviously correct, thanks!

Bart
