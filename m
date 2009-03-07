Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZCGTXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZCGTXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 14:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZCGTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 14:23:38 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:57467 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbZCGTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 14:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gwIx963IMN9rE2ROYM8iN6//Iwk5eRk9JlZKkuZF1miREpXcx7J7hWGACU3o1UFcY0
         GHcWlt767fYQaIIaTvmFQEitoWBicMU06l3psza38B+lIL7D3M4qS7/A9hMUQH3UBzTv
         xgiJuwCDUml5OU7FLta8HT+u2FvRs5R4xDCYI=
Date: Sat, 7 Mar 2009 22:30:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] A simple way to determine if the kernel needs HIGHMEM64G
	to be able to use all the installed memory
Message-ID: <20090307193026.GA2165@x200.localdomain>
References: <49B254C6.8010507@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B254C6.8010507@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 01:04:38PM +0200, Ozan Çağlayan wrote:
> When the installed memory size is >= 4GB, kernel drops some messages like
> 
> Warning only 4GB of memory will be used
> You have to enable HIGHMEM64G.
> 
> I checked that the message comes from arch/x86/init_32.c after checking
> max_pfn.
> 
> I'm quite dumb about the internal structures of the kernel but, wouldn't it
> be possible to create a simple read-only sysfs object like kexec_loaded
> that will contain "1" when the kernel needs HIGHMEM64G to see all of the memory
> and "0" when it doesn't?

Why do you need a file? If kernel says to enable HIGHMEM64G, enable it.

> I think that it would be a nice facility for distribution kernels to detect
> the need for a PAE enabled 32-bit kernel by just reading some /sys/.. entry.
