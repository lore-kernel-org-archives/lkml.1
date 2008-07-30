Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYG3WXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYG3WXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYG3WXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:23:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:25437 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYG3WXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=iC4RM3PeuiuMM8g/cKwdPzjDHgloxILIDWC6sA4ep2lJ3VfyUmbJzt7k3RckwJtHEK
         lqSY2xl88yAE9daONNpePsuBQwyPlBcMge1nBmXjnrJRsd7GMgl4haYG75E2KW5s53zs
         mMcXrLWLMjBXWvx/yenPAp2MmlLCgNLtk7zK8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ide-cd: fix endianity for the error message in cdrom_read_capacity
Date: Wed, 30 Jul 2008 23:23:24 +0200
User-Agent: KMail/1.9.9
Cc: petkovbb@gmail.com, gregkh@suse.de, ptesarik@suse.cz,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, jack@suse.cz
References: <1217405406.11834.11.camel@elijah.suse.cz> <200807302125.54124.bzolnier@gmail.com> <20080730130255.9538678a.akpm@linux-foundation.org>
In-Reply-To: <20080730130255.9538678a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302323.24807.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008, Andrew Morton wrote:
> On Wed, 30 Jul 2008 21:25:53 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > > > Bart owns this patch now.  It got lost for a month and it has already
> > > > been fixed twice and it is also on the route to 2.6.25.x and 2.6.26.x,
> > > > so it'll get complicated.  Not a happy little patch.
> > > 
> > > Greg, can you please apply this one on top of -stable.
> > 
> > The usual policy is to not apply to -stable patches which are not in
> > Linus' tree so please notify stable@kernelorg team after patch hits
> > mainline.
> 
> Please put a Cc: <stable@kernel.org> into the changelog.  Then the
> stable people will notice it when Linus commits it.

Done.
