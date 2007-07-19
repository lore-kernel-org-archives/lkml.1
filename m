Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbXGSIYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbXGSIYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbXGSIXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:23:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:30439 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXGSIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CwVnPXwv9SLHD99l5KiNPUavkEd5sKzLKhoK7Rxt2iVbD7slkWcxPjoKJTiHoDTdCzua9fAY4Y+blmD2YfEpdlrcE21evmSy0Wqpx/02r8Hu1PGV8KWsorNJP6znEPAFwrIOJft890NeZnDCnFTBOV0KHys4sbmv1y0EhOXC34I=
Message-ID: <21d7e9970707190123n328300a6m8debe274b959ab30@mail.gmail.com>
Date: Thu, 19 Jul 2007 18:23:40 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: cmpxchg is not available to generic code
Cc: "David Miller" <davem@davemloft.net>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070719012141.47911bd7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
	 <20070719.002716.30181989.davem@davemloft.net>
	 <21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
	 <20070719012141.47911bd7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 19 Jul 2007 18:15:03 +1000 "Dave Airlie" <airlied@gmail.com> wrote:
>
> > Maybe we could add CONFIG_HAVE_CMPXCHG and let DRM depend on it..
>
> That would certainly be better than adding a sprinkle of architectures
> in DRM Kconfig dependencies.
>
> I don't know how important DRM is on ARM.  Zero?
>

I'd guess zero I suppose if you wanted you could hook up a PCI
graphics card on ARM, but if you do that I think you could implement
cmpxchg :-)

Dave.
