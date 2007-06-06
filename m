Return-Path: <linux-kernel-owner+w=401wt.eu-S935515AbXFFVTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515AbXFFVTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934493AbXFFVSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:18:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:57147 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbXFFVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kLs2eZZe53FfsFPLm4nZiT6WQW/bUvnjsri/H0MQC/pgB8TCFYKuSppSwhsnBhsEjxKy5eyGMpFlD2jQQmjIb5SJkTm20Va1zz/qzUGzTL4E+V9TuW/TfgiuKz7Rwv6hSC83wmjAeeIZFr8gjDTsDp613TlRZb99/OA3koAEPSE=
Message-ID: <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
Date: Thu, 7 Jun 2007 02:48:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: 4Gb ram not showing up
Cc: "Tom Moore" <tmoore@spatial.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20070605185721.GW10006@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46642C60.209@spatial.ca>
	 <20070604191052.GD10008@csclub.uwaterloo.ca>
	 <46646B4C.2070707@spatial.ca>
	 <20070605185721.GW10006@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> [...]
> A better description would be:
>
> "Select this if you have a 32-bit processor and memory mapped in the 1GB
> to 4GB address range."
> [...]
> That one would be better as:
>
> "Select this if you have a 32-bit processor and ram mapped in the address
> range above 4GB."

Ugh, no! How can we expect the user compiling a kernel to be *so*
familiar with address space re-mapping / BIOSen (_his_ particular
BIOS, specifically, and what / how it re-maps memory) / etc to be
able to answer such questions? "Select ... if you have ... RAM
installed" is perfectly clear, simple, and all that's needed.

BTW, just imagine what a user would need to do to make things
work as per your proposal. Build some kernel (don't care about
memory loss), boot and find what his firmware prefers to do with
address space (or else read up the BIOS documentation!) and
_then_ again build a new kernel, this time selecting the options
appropriately ...

Also, note that the change you're proposing is unnecessary! As
Andi pointed out, this issue has more to do with broken BIOSen
and the proper fix for Tom is to contact his vendor and flash /
upgrade the BIOS firmware. I don't see anything wrong with the
Kconfig help texts.
