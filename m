Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYDFQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYDFQhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 12:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYDFQhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 12:37:33 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:50001 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbYDFQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:37:32 -0400
Date: Sun, 6 Apr 2008 09:37:31 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Jack Harvard <jack.harvard@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How does Linux measure CPU frequency?
In-Reply-To: <a72f6a3c0804060930l157ec1f5xc090dfdc3ca4a011@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0804060935520.7751@twinlark.arctic.org>
References: <a72f6a3c0804060930l157ec1f5xc090dfdc3ca4a011@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux knows what style of cpu it is running on and uses non-portable 
techniques to read the time-stamp counter.

lmbench uses some really nice tricks to estimate the cpu frequency in a 
portable manner... all it requires is that at least two of the N code 
sequences it times take a co-prime number of cycles.

-dean

On Sun, 6 Apr 2008, Jack Harvard wrote:

> Hi,
> 
> I want to find out how Linux calibrates the frequency of CPUs, and
> want to compare with the way how lmbench measures processor frequency.
> I had a thorough google search of this topic but didn't get too much
> useful results.
> 
> Thanks a lot,
> Jack
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
