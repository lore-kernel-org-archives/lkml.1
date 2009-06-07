Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZFGO6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZFGO6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZFGO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:58:34 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56176 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFGO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=slpTi5iGvJ6UV7WiQT7B0RtWsM2ts/OetxlTgCLg0UtcmJVtOo7kweVY8k3bUM6TZD
         1oQkVNU3Mo9nPotRcAt3p82UvRVvPxjpqLRZHBxc1sB7tzyMk29e/0hjbhDWx9cIaKzL
         HRFCkstNZ1GW+Vp4I61vr2qfnDPS5qvS//VZY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 17:03:43 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906071632.30914.bzolnier@gmail.com> <20090607154048.07a7fb65@lxorguk.ukuu.org.uk>
In-Reply-To: <20090607154048.07a7fb65@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906071703.43285.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 16:40:48 Alan Cox wrote:
> > If you want to discuss any code that I push upstream then *please* quote
> > it in your mails so we all can see what parts you question and discuss it
> > based on technical merits.
> 
> This isn't about technical merits - it is about *risk*. You don't submit

fs/partitions/check.c change doesn't influence anything other that behavior
of ide-gd driver and has been ACK-ed by Al Viro.

> patches to core code to add new features just before the final release.

This is not a feature but really a bug fix (requested by you along other
people in the past).
