Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYGaKKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYGaKKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGaKKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:10:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:21397 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYGaKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LIe4SV9hXxprzSRe1MR/Efd33CalyL3jcEJ55bboMPzhf1GqAWqOvoxmhjb3Fufo6A
         06z+v0rBFnm9ezfY69MzCO9dxaGnb4LdwFUa2zsLyOUk/ANiAnu2vtatNVQESDhJ3w2S
         AbfXLBPjymAGmP32gl3C75J7e00yn7Ctgo2bw=
Date: Thu, 31 Jul 2008 12:09:29 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       bcrl@kvack.org, linux-aio@kvack.org, akpm@linux-foundation.org
Subject: Re: [patch 1/4] Configure out AIO support
Message-ID: <20080731100929.GA9206@mx.loc>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.690886851@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731093220.690886851@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 11:27:04AM +0200, Thomas Petazzoni wrote:
>This patchs adds the CONFIG_AIO option which allows to remove support
>for asynchronous I/O operations, that are not necessarly used by
>applications, particularly on embedded devices. As this is a
>size-reduction option, it depends on CONFIG_EMBEDDED. It allows to
>save ~7 kilobytes of kernel code/data:

Shouldn't this also make sure not to install aio_abi.h or at least an
empty aio_abi.h?
