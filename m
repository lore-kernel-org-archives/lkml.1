Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZEYXKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZEYXKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZEYXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:10:37 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35323 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZEYXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=sVmHV88e+TPzwejwXetB7pDcxPnHJdPfJSlfd+mGJkHt6i/7uABjkA6kuzsVqhgrnN
         M3gugE8/PMluwBXZvbMRHO8LYwesXU+328ZA2HqXyN6PTK6M5QMJM5V3Qcy0GRUWy4ey
         tuvPSqKUBX7avjN7jifzEVGyKIp7ThhuTYWTI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: add warning about possible HPA compatibility issue
Date: Tue, 26 May 2009 01:15:00 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Jacob <fun2program8@yahoo.com>,
       Christopher Hogan <chris.c.hogan@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200905252348.08970.bzolnier@gmail.com> <200905260036.17718.bzolnier@gmail.com> <20090525233814.4cb8b1c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090525233814.4cb8b1c2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905260115.00794.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009 00:38:14 Alan Cox wrote:
> > > NAK - this is extremely misleading and will just randomly terrify users,
> > > who may then set the paramater and corrupt things like BIOS save areas.
> > 
> > Please propose better description.
> 
> As was discussed before
> 
> Tejun has a patch in the queue which exposes the HPA and real sizes to
> the OS

In queue for 2.6.30?

> Libata can support revalidating a disc
> 
> Once the HPA/Real size data is there the tools can be tuned for this and
> a sysfs node added to switch hpa on/off per disc. At that point this can
> be done by the user space intelligently.

Unless you happen to have partition with tools in HPA area etc.

Also care to post link to the existing user-space tools with added HPA
support and documentation how to use them so I can start pointing people
reporting problems in this direction?

> The fact this is a user parameter is itself a problem.

Yes.  It is a problem but we can't reverse the history.

I fully agree w.r.t to proper handling of HPA but we need "something" in
the meantime because it is *real* issue resulting in *real* users filling
*real* bug-reports (which unfortunately always get assigned to me first
so I'm needlessly wasting my time on them).

IOW Please stop downplaying bug #13365 which this patch tries to alleviate.

I'm adding Andrew to cc:...
