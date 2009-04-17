Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZDQHcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZDQHcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbZDQHc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:32:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:21257 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549AbZDQHc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MB1NgdaZNVAjz/sjhMB5dzG7kg0Yd3NO6tIot5kw5npA1x+MKpUdItJziNsaIlwmG+
         dk+r8dLYzkj1Su16EPnNhgEuEZsWUeAofHpTdvJUjPyhkVYgFI46FofVMkdfCBX/wwip
         EMlfrTuOtCKohaYmTyCkpFXFStRS5/R6GZpFk=
Date: Fri, 17 Apr 2009 16:32:23 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] loop: use BIO list management functions
Message-ID: <20090417073223.GB3367@localhost.localdomain>
References: <20090417063217.GA3515@localhost.localdomain> <20090417063702.GA16744@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417063702.GA16744@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 02:37:02AM -0400, Christoph Hellwig wrote:
> >  /*
> > - * BIO list managment for use by remapping drivers (e.g. DM or MD).
> > + * BIO list management for use by remapping drivers (e.g. DM or MD) and loop.
> >   *
> 
> 
> I don't think this needs changing, that was just examples.

OK. I kept only s/managment/management/ typo in new patch.
