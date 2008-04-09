Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYDIQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYDIQ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYDIQ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:28:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:14439 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYDIQ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WDx626dJxrFBPet0FtqV8ahCN8yxx8z4FsYKPQ+gRRr1cQNJ+0chPJLvj4bak4X+wTskRAXCAgvIVbyaxjPkylBbsFl+4LEPRGkW7eePNLxY/6X4T2oDkZLsh7yDzbahduTyPbfGw2wudJSk/9LD5HgBGNQrJQhVPCES3UneOwY=
Message-ID: <cf40c6a90804090928l5f2b70bdxfdb9e61cfae76f22@mail.gmail.com>
Date: Wed, 9 Apr 2008 18:28:28 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: VM - a plenty of inactive memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
	 <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
	 <2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the output of free:
-/+ buffers/cache:   30718212    2547704
Information in frees man page is very sparse, what's the
interpretation? I will try the drop_cache thing in the night.
Thanks!

2008/4/9, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> Hi
>
>
>  >  i know this. But why the kernel locks that memory for a so long time
>  >  (2 days now)?
>
>
> maybe, page cache consume it.
>  it isn't mean that waste memory.
>
>  > Is there a way to enforce the reclaiming?
>
>  following command drop all cache. (but I don't reccomend it)
>
>  # echo 3 > /proc/sys/vm/drop_caches
>
>
>
>  >  And how can i
>  >  find out, which process owns that memory.
>
>
> please use free command and see second line(+ buffer/cache'ed free mem).
>
>
>  >  The problem is, that i can't
>  >  accept, that the free memory fell down to 50MB, when i have 24GB in
>  >  the nirvana. The system was recently very close to the awkward
>  >  situation to swap to disk, and i bet it will do so in the next few
>  >  days, because it happened before. Unintelligible, if one got that much
>  >  ram.
>
>
> may be, it is not happend forever.
>
