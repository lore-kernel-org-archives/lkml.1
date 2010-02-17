Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0BQRGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:06:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41311 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0BQRGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:06:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dA5PQ3skWiBSzB1jzE3QHuJKQ38KL4qpHO+BSrasadZfSCY+Edwx8LeQKtTHEDM4vF
         WJGcFOvuuYHbEs+rj//1rKNe0Iw3JjQdbR2i9KgKCrEj1qCm3p0u6tly5FoOcbXUuGbQ
         9fvwzRz5c3fV1cvJjtLinhOuPt70OIxAYyHQU=
Date: Wed, 17 Feb 2010 18:06:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: prasad@linux.vnet.ibm.com, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100217170639.GE5041@nowhere>
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere> <4B785952.8020706@redhat.com> <20100214204130.GD5479@nowhere> <4B7881AC.5070209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7881AC.5070209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:05:16AM +0100, Michael Stefaniuc wrote:
> The easiest to bootstrap the build environment is to use the package
> management of the distribution, e.g. yum-builddep wine on Fedora.  But
> there are also howto's for other distributions on
> http://wiki.winehq.org/WineOn64bit


Thanks, should work fine for me.



>> Sure, let's fix the first problem to begin.
> That regression isn't there anymore; I had seen it when the regression
> search brought me to 66cb591. Now all other tests in ntdll/exception.c
> pass just fine.


OK, will send the second fix soon (the one that fix the dr7 mismatch).

Thanks.

