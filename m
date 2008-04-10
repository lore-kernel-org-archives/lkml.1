Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYDJRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYDJRg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbYDJRgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:36:14 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:64592 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbYDJRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tm0Da6SudGx84bho4u9DfEKmxg58nmZLeMhzFuwgmkX29lXvPR+3xDhlEeE75iHO2KL6nWU+etTtb5YjZyMnY27PoMyKcvHog/cDYVAL7SDlH4rXDELM6JT2fPT2APa/85gNcUgEYDNUFcxowSdFcHdFFuTxs4522OFG51vv2F0=
Message-ID: <36ca99e90804101036o407dda7dyc303bd87f46c5cfc@mail.gmail.com>
Date: Thu, 10 Apr 2008 19:36:12 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Cc: "Paul Jackson" <pj@sgi.com>, travis@sgi.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080410173016.GA28068@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
	 <20080410071009.a5232b12.pj@sgi.com>
	 <36ca99e90804100914n4b08cc9di9a6ab8b936f25644@mail.gmail.com>
	 <20080410173016.GA28068@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 7:30 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Thu, Apr 10, 2008 at 06:14:55PM +0200, Bert Wesarg wrote:
>  > On Thu, Apr 10, 2008 at 2:10 PM, Paul Jackson <pj@sgi.com> wrote:
>  > > Bert wrote:
>  > >  > Btw, I think you can now push for a deprecation of the 'old' mask
>  > >  > attributes, with the justification you have given above. The other
>  > >  > possibility is to change sysfs to provide bigger attribute buffers
>  > >  > (CCed Greg for this).
>  > >
>  > >  On the other hand, and my main point of this message, I can't
>  > >  see deprecating the mask format files on account of this sort
>  > >  of analysis.
>  > >
>  > My statement from above doesn't reflect my opinion. I'm still in
>  > flavor with the mask output. And from this discussion, I found a new
>  > point for the mask output: its bounded ;-)
>  >
>  > I just wanted to note, that these new list attributes would be the
>  > only way to 'change' the api, ie. introduce a new api and deprecate
>  > the old one, and not change the format of the present api.
>  >
>  > Unfortunately, to support the mask attributes beyond 4k cpus, sysfs
>  > has to support greater attribute buffers.
>
>  Well, it does already today, you just have to work at it :)
>
>  What we can do for these types of files, is to use the "binary
>  attribute" file format.  With that, you get full control over the buffer
>  size and other operations.
>
>  So someone should just wrap up the cpu mask sysfs file usage in a
>  function that uses the binary attribute instead.  Then everyone who uses
>  the cpu mask in a sysfs file can use that function instead.
>
>  Sound reasonable?
Very. Thanks.

Bert
>
>  thanks,
>
>  greg k-h
>
