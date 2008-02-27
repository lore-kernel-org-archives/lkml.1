Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYB0RmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYB0RmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYB0RmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:42:06 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:18930 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbYB0RmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aby187tw5VR/dsKM/u8R1G3DP4vxfIBHJ17yvSWq4v+OOBtshRdpRmS+GDOAbFilvL6wwxCEWAwVIMfYepNLNLfm3kHVT0nlg/RaMsRgduGiNMSV7Sn+fNCwJYfKn6e5pgDVEHpLAtEzqIgGOyXV4SOdgvYLH6xzY6Dz2cb9vug=
Message-ID: <4d569c330802270941p681eb337x9a6d9cbcc2c4687f@mail.gmail.com>
Date: Wed, 27 Feb 2008 12:41:57 -0500
From: "Kevin Coffman" <kwc@citi.umich.edu>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.24-sha1: RIP [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Kevin Coffman" <kwc@citi.umich.edu>
In-Reply-To: <200802261446.57109.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210140031.GA1754@martell.zuzino.mipt.ru>
	 <20080219204711.GA1756@martell.zuzino.mipt.ru>
	 <20080219220106.GB1756@martell.zuzino.mipt.ru>
	 <200802261446.57109.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: b675235be8d60da3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:46 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Wednesday 20 February 2008 09:01, Alexey Dobriyan wrote:
>
> > On Tue, Feb 19, 2008 at 11:47:11PM +0300,  wrote:
>
>  > > > Are you reproducing it simply by running the
>  > > > ftest03 binary directly from the shell? How many times between oopses?
>  > > > It is multi-process but no threads, so races should be minimal down
>  > > > this path -- can you get an strace of the failing process?
>  >
>  > Speaking of multi-proceseness, changing MAXCHILD to 1, nchild to 1,
>  > AFAICS, generates one child which oopses the very same way (in parallel
>  > with generic LTP) But, lowering MAXIOVCNT to 8 generates no oops.
>
>  Thanks, I was able to reproduce quite easily with these settings.
>  I think I have the correct patch now (at least it isn't triggerable
>  any more here).
>
>  Thanks,
>  Nick

Hi Nick,
With this patch, I'm getting "bad data" errors while running the
connectathon tests from a Solaris NFS client to my Linux server.  (The
failing test writes a "big" file (1MB) and reads it back, verifying
the data read back is correct.)  Let me know if I can provide more
details.

K.C.
