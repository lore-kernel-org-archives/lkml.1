Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYEOHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYEOHlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbYEOHku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:40:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:36150 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbYEOHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jnbzj8BWfPwLSvA58XZWSaQWE/P0ZUdGTn6MVDjEWsShIPHJrXcmqvtuPkORG26vYnDwik4M7kRHVJnFHkS+QvuqFG9x4y+WasfgO82qvLcLQyAfHIQg683EM8jKtkJWTp4GMozCUK2ktU1DA+cmV48A0qmwiqCa9/XF7RDMXoY=
Message-ID: <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
Date: Thu, 15 May 2008 09:40:47 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: How to avoid data copies in a driver ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
	 <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 14, 2008 at 11:23 PM, linux-os (Dick Johnson)
<linux-os@analogic.com> wrote:
> You memory-map the data. Impliment mmap() in your driver.
> You can also impliment poll()  { select() } so your
> application knows when new data are available.
>
> You cannot use a user-mode file-descriptor in the kernel.
>

Why not ?

I'm suprised because what I need doens't seem so uncommon, usually
devices send or
receive data to/from files. So a helper (system call ?) to achieve
that other than the basic
read/write seems needed, no ?

-- 
Francis
