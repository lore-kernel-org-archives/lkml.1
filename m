Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbXLPB5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbXLPB5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 20:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXLPB5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 20:57:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:24542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbXLPB5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 20:57:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=vtw4LWA+tDuU550X8k+Pc7sUxOAzFbiBkCI/DY0RWY644jBamrHuGvlSBKnoBR5+IHpnVL0LoenQkkUBqlNHp++AczZX4O1tYB+pIUAKbrT+lLl3hUqtG07A4C5R/2WwG1ZyEA3qoWoirqwocda5BdfiHrsP/YbRn1i/xj01aoU=
Date: Sun, 16 Dec 2007 02:58:31 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/core.h: include sound/driver.h
Message-ID: <20071216015825.GA26986@joi>
References: <20071208205040.GG5087@joi> <s5hwsrh5yjt.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hwsrh5yjt.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 12:02:46PM +0100, Takashi Iwai wrote:
> At Sat, 8 Dec 2007 21:50:45 +0100,
> Marcin Ślusarz wrote:
> >
> > sound/core.h: include sound/driver.h
> >
> > include sound/driver.h in sound/core.h because core.h
> > uses SNDRV_CARDS (which is defined in sound/driver.h)
> >
> > Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
>
> Right now I have another (bigger) change for this include path, so
> this patch won't be needed any more.
>
> I applied the patches to sound/* except for this one and
> sound/memory.c.   Thanks!
>
Is there anything wrong with patch for rawmidi [1]?

Marcin

[1] http://lkml.org/lkml/2007/12/8/164
