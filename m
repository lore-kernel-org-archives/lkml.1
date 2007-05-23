Return-Path: <linux-kernel-owner+w=401wt.eu-S1765884AbXEWODr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765884AbXEWODr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbXEWODk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:03:40 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:46175 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXEWODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SMQ5ntfT++ASOT9rh1AZRWzfTfaOpxxWkBCEFaR/4aD90lNsaX8mkDyClNc84nj4CemPgZWPzd4NMp61R3Lk69ttrzFD1XJa3T7AJ4mpWl82aCYD6TFlQjAsL8CxBroBDrO9vuWWiRJm9MBNfKrsdQYDHr7YvruCfQ6I2uhOp/k=
Message-ID: <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
Date: Wed, 23 May 2007 19:33:36 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
In-Reply-To: <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	 <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	 <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
>
> Fair enough. However, this rather important issue is pretty much
> undocumented (source code comments don't count)

If header file for public interface (<linux/lzo1x.h> documents about
'unsafe' vs. 'safe' then it should be enough.

> and Reiser4 is
> already using the lzo1x_decompress() function rather than the
> seemingly more appropriate lzo1x_decompress_safe() function...
>
> http://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-
> rc2/2.6.22-rc2-mm1/broken-out/reiser4-use-lzo-library-functions.patch
>
> Perhaps a rename is in order:
> lzo1x_decompress() => lzo1x_decompress_unsafe()
> lzo1x_decompress_safe => lzo1x_decompress()
>

Or perhaps make reiserfs use _safe() instead - I think Richard has
already submitted patch for same.

- Nitin
