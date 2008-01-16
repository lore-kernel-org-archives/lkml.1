Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYAPWj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYAPWj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYAPWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:39:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:32773 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYAPWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pSNQ3VzUD7JiuFjD4LEGYUP2EtfBviyFQ0kykFkQ8JpL5FRoExKEGpkAnxGeVbrH3gfcOaC7QqzPmb5dvF9E3X06FhFKZ07b6AfKXVuhdC4/SunRUFcYDhfB6AP3MUVk/mR9lmuc07MO7pA9fIl48aqiXqU/nQ+zn5F6tzMyK2s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Date: Wed, 16 Jan 2008 23:08:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <200801142332.58341.bzolnier@gmail.com> <20080115200921.GA5699@gollum.tnic>
In-Reply-To: <20080115200921.GA5699@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801162308.15217.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, Borislav Petkov wrote:
> On Mon, Jan 14, 2008 at 11:32:58PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 14 January 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Sunday 13 January 2008, Borislav Petkov wrote:
> > > > ..and replace them with flag enums.
> > > > 
> > > > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > 
> > small update:
> > 
> > PC_ABORT is never set and may as well be removed in a pre-patch
> 
> Here you go, the one below should be pushed first...
> 
> --
> From: Borislav Petkov <bbpetkov@yahoo.de>
> Date: Tue, 15 Jan 2008 20:34:50 +0100
> Subject: ide-floppy: remove unused flag PC_ABORT
> 
> This flag was never being set in the code so remove it. By the way, the
> code in the second patch was being executed unconditionally, i.e. in case
> pc->retries > IDEFLOPPY_MAX_PC_RETRIES is true (actually that is the only case
> when the outer if-test passed), !test_bit(PC_ABORT, &pc->flags)
> was always true so the comment is now incorrect and has to go.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

thanks, applied
