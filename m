Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZCENui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZCENui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZCENu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:50:29 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:41955 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZCENu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:50:29 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: drop_caches ...
Date: Thu, 5 Mar 2009 14:50:22 +0100
User-Agent: KMail/1.9.10
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
References: <200903041057.34072.M4rkusXXL@web.de> <200903051255.35407.M4rkusXXL@web.de> <20090305133603.GA22442@localhost>
In-Reply-To: <20090305133603.GA22442@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903051450.23163.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+UOU2dVM+FWegVx5a8FSOKbNSMOLDl69sAnHJB
	otN1C9uJvjGMOj6dvnQV0Gqw6GOLxBUL5WT2xoZlrjSJlDEUJd
	QBrLM0C3s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. März 2009 schrieb Wu Fengguang:
> Hi Markus,
> 
> On Thu, Mar 05, 2009 at 01:55:35PM +0200, Markus wrote:
> > > Markus, you may want to try this patch, it will have better chance 
to figure out
> > > the hidden file pages.
> > > 
> > > 1) apply the patch and recompile kernel with 
CONFIG_PROC_FILECACHE=m
> > > 2) after booting:
> > >         modprobe filecache
> > >         cp /proc/filecache filecache-`date +'%F'`
> > > 3) send us the copied file, it will list all cached files, 
including
> > >    the normally hidden ones.
> > 
> > The file consists of 674 lines. If I interpret it right, "size" is 
the 
> > filesize and "cached" the amount of the file being in cache (why can 
> > this be bigger than the file?!).
> 
>           size = file size in bytes
>         cached = cached pages
> 
> So it's normal that (size > cached).

Yeah, I just wondered because sometimes its size < cached, buts thats 
because cached must obviously be a multiple of 4 KB. So no problem 
here ;)

Thanks,
Markus
