Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXLBSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXLBSml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXLBSmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:42:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:57566 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXLBSmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:42:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ljcII6pLQuiNScSHA+OWj9bPobAZG52XcxMR9zOs3pOCaFxVCdhoTzTt1gufPV6QI+Ze5vVPHQ8fbHjAZk++xbqqxmn7TtrTKreA78n7r0QlFh5rprO+cWCJxfWLBWd7ywJ08euAromAyDwE0zYZ5fpSHHGtV7/p7D9b93+Upx0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Nick Warne <nick@ukfsn.org>
Subject: Re: Peculiar out-of-sync boot log lines
Date: Sun, 2 Dec 2007 19:34:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20071129193728.2f1c237e@linuxamd.linicks.net> <200712012259.35152.bzolnier@gmail.com> <20071202173130.1c645dbc@linuxamd.linicks.net>
In-Reply-To: <20071202173130.1c645dbc@linuxamd.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712021934.26043.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 December 2007, Nick Warne wrote:
> On Sat, 1 Dec 2007 22:59:35 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
>  
> > Thanks for reporting/debugging it guys!
> > 
> > > Something in there needs to insert a '\n' before the "skipping
> > > word" message. Since it doesn't do that right now, the KERN_DEBUG
> > > string appears as "<7>"
> > 
> > This seems like a good occasion to fix ide_dma_verbose() for good
> > so... :)
>  
> > This patch should fix the following problem with out-of-sync IDE
> > messages reported by Nick Warned:
> ...

Sorry for that, I fixed it in "take 2" of the patch.

> I was only reporting it... not warning anybody ;-)

Hehe... :-)

Bart
