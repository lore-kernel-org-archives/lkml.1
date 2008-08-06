Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYHFNqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYHFNqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYHFNqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:46:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:25050 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYHFNqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LdJrPgxVi954xZoXmfAkj4BvY+EG7QP7W6lYT3tE6ag/YfPFKiz5K0Bm/NZGbYjhXc
         atRXGupBfucex2hPzX3N/Cia+uQOX4ULHQw2c2Eu68/scImg7rwWxz+LgQkPQsn/SIVG
         NF2rp4uw1sWtPvvrbvc6uBvjEuEhGQmse0fGM=
From: Michael Brennan <brennan.brisad@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Waking up from suspend regression
Date: Wed, 6 Aug 2008 15:44:59 +0200
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, matthew@wil.cx, jeff@garzik.org
References: <200808060325.54537.brennan.brisad@gmail.com> <20080806083129.GC20055@kernel.dk> <489961B9.6010207@gmail.com>
In-Reply-To: <489961B9.6010207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061544.59462.brennan.brisad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 10.32.57 Tejun Heo wrote:
> Jens Axboe wrote:
> > On Wed, Aug 06 2008, Michael Brennan wrote:
> >> Hi,
> >>
> >> I am having some major problems with the newest kernels on my Thinkpad
> >> R61i and I'm doing my best trying to debug the problems.
> >>
> >> One problem is waking up from suspend to RAM. Earlier kernels worked
> >> fine (e.g. 2.6.25), but with the latest the system is unusable after
> >> waking up. When trying to wake the computer up it first is completely
> >> unresponsive with a black screen. After about 40 seconds it comes back
> >> alive and shows the locked screensaver. But whatever I do I just get
> >> error messages, trying to unlock the screen, it says authentication
> >> failed for some reason. If I try to log in from console I just get
> >> kernel messages about I/O errors from the SATA HDD.
> >>
> >> I have bisected this and get this behavior after the patch:
> >> [ce6fce4295ba727b36fdc73040e444bd1aae64cd] PCI MSI: Don't disable MSIs
> >> if the mask bit isn't supported
> >
> > Same here, sata is dead after the resume. Thinkpad X60.
>
> Known bug && patch available.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11178

Well, look at that.
I'm sorry I missed that bugreport, could have saved me quite a few 
recompilations. I'll try the patch, thanks.

-- 
Michael Brennan
