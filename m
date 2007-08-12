Return-Path: <linux-kernel-owner+w=401wt.eu-S937511AbXHLSHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937511AbXHLSHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935146AbXHLSHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:07:13 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:6059 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934980AbXHLSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ebkScdfRZyGTkwkhczBlxpxtojV6t6y/XXfxfKW8/6nYKvLpk34Ctz6aUBgYgPXOPMBtjtJ2j/INc035oFX8xQ3r7yKaMKZLGjmNCzvNliLkA67J9Y6lSEkQUdr0b8+qnNXt42DYS2EDBXz/TtMJHrhvn7iMXl6dFzJyQnyeJdw=
Message-ID: <8bd0f97a0708121107i553bf521v6022e225fca2b0d1@mail.gmail.com>
Date: Sun, 12 Aug 2007 14:07:10 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Michael Matz" <matz@suse.de>
Subject: Re: [PATCH] remove strict ansi check from __u64 in asm/types.h
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Olaf Hering" <olh@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708071556000.23011@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806172331.GA8102@suse.de> <46B75D3B.6080101@zytor.com>
	 <8bd0f97a0708061713y75651621u8b2e57b1be5a61c8@mail.gmail.com>
	 <Pine.LNX.4.64.0708071556000.23011@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Michael Matz <matz@suse.de> wrote:
> That would still make it not work with programs compiled with just -ansi
> or -std=c90 (both being equivalent) with -pedantic added.  There still are
> such.  Only for that case is the __extension__ prefix necessary.

i thought the point was it's supposed to fail with just -ansi and the
default standard (c89)

at any rate, as long as your changes account for all the files in the
patch i posted, that's fine by me
-mike
