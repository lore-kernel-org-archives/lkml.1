Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZDGTSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZDGTSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDGTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:18:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZDGTSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:18:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64 (HP nx6325), NFS broken
Date: Tue, 7 Apr 2009 21:18:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>
References: <200904070047.56172.rjw@sisk.pl> <1239061566.6196.13.camel@heimdal.trondhjem.org>
In-Reply-To: <1239061566.6196.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072118.48049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Trond Myklebust wrote:
> On Tue, 2009-04-07 at 00:47 +0200, Rafael J. Wysocki wrote:
> > Also, mounting directories over NFS doesn't work (I think it oopses, but
> > didn't have the time to look at it more closely).
> 
> There is a known double free issue that affects the 'proto=' mount
> option (we call kfree(string) twice). Please could you check that the
> following patch fixes it for you?

The problem is fixed in the current -git, so I guess the patch is in there. :-)

Thanks,
Rafael
