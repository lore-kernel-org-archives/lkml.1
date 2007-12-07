Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXLGTkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXLGTkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXLGTjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:39:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:61914 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbXLGTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:39:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MnCeNijLJGcbBJMTh+jm0hjoZ4FwbcJ4ttCSLCThpYdvy+Qh302b0PwYg+L/o7o1iaEBSGwKnSo2ZXbeFSOdvkuzhtZr4hGmeucYP1Wv0RYzGapueZDdriPixJ+0ZjxlUBZjxV1Xlgr6OlBEDY6Kabclfdyv/fokNnLn7gzYoVI=
Message-ID: <fa4052ef0712071139x30ada982r570513c5a0fb2657@mail.gmail.com>
Date: Fri, 7 Dec 2007 14:39:52 -0500
From: Shane <gnome42@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <fa4052ef0712071116x2b727faau190ec14e4b2a2d47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <20071207040219.e231cbc7.akpm@linux-foundation.org>
	 <fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
	 <1197053179.7532.23.camel@heimdal.trondhjem.org>
	 <fa4052ef0712071055r2fe33f2ep34fed2537970c8ef@mail.gmail.com>
	 <fa4052ef0712071116x2b727faau190ec14e4b2a2d47@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
...
> Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> spots and check for other regressions.

Hmm, I installed a new kernel built from the same sources on the NFS
server. And now I don't see anything at all in the crossmnt dirs.

ls /dirA/dirB/dirC  --> zero output (empty dir)

Are there any other pending fixes?

Shane
