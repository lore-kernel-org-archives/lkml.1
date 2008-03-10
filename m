Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYCJXNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYCJXNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYCJXM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:12:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYCJXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=PZjOsKLFTYZeODSIn2iExw8C93DeoVHvFD7xEapkD91GfGY1cuYYSCFY7gs3Jl8ucf+aOuHr/m7inqOnX5WiMPiL1J13XQqOiuDt72Pke+GFR/lcuj/bCu5zAR7IcWuY5PWz4BCkiDr62iTN4OGct/osswRV7iUp7Fsl55/5DYc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/4] ide-tape: remove pipeline functionality-v2
Date: Tue, 11 Mar 2008 00:24:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803110024.35174.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 09 March 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here are some patches removing the code for adding r/w requests to the pipeline.
> Instead, they are being queued straight onto the device request queue now. In
> addition, pipeline speed/control calculation has been removed since it becomes
> also unused.
> 
>  drivers/ide/ide-tape.c |  334 +++++++-----------------------------------------
>  1 files changed, 46 insertions(+), 288 deletions(-)

Thanks for re-doing the patches, I applied everything (it seems that thanks
to the recast the changes become more obvious and we may now simplify patches
even more - please see the other mails).

Bart
