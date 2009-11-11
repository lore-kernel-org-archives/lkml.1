Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZKKWu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZKKWu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbZKKWu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:50:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58903 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326AbZKKWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eV+SJaeFHc5MMSI3o5a9EK/dG1spnV67SJ0qaoiNfELmLRA5/tgSwj+HsZRwkIHrph
         1/XCKh2bZAaNTBZqmiWp+T2nwnczloOxxyBjLGGSM/Cst7url9QIyDH1cMOwYi30mHL/
         qFTHWpXffywXsfQMmAqzAAZZKZDkFIolV3Tr4=
MIME-Version: 1.0
In-Reply-To: <4AFB3C9D.4020609@rtr.ca>
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
	 <4AF8F363.3010806@rtr.ca> <200911101651.24912.bzolnier@gmail.com>
	 <84144f020911100808y55f5bfa2v5c203b356583a7b5@mail.gmail.com>
	 <4AFB3C9D.4020609@rtr.ca>
Date: Wed, 11 Nov 2009 20:50:29 -0200
Message-ID: <a4c8a6d00911111450y7e451071h3f0ede0a1003678b@mail.gmail.com>
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
From: Thiago Farina <tfransosi@gmail.com>
To: Mark Lord <liml@rtr.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, jgarzik@pobox.com,
       mlord@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 8:37 PM, Mark Lord <liml@rtr.ca> wrote:
> Looks like unnecessary churn and obfuscation to me.

Obfuscation? Are you saying that just because you wrote this code?  So
what is the usage of a macro? I think you are having a defensive
position here.

The macro is self-explanatory, ARRAY_SIZE, so the macro gives you the
*size* of the array. You don't need to know how that is done, if you
want, just go to the declaration of the macro.
