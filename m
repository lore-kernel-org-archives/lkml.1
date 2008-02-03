Return-Path: <linux-kernel-owner+w=401wt.eu-S1765032AbYBCLh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765032AbYBCLh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYBCLhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:37:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:43243 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYBCLhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=ARNe5OT+XgLLnfucHScluEcIpGUGOA8hL1az96swx3UYwvCQmbRgCFpb36b0P0OnS55qHjeTa6cCSnoxf5TYLrO3oV80pmXb1iMq+H4XEk4VM13vhrSdqU0IRis3XTJEipofPcqnTBrImsdB4QXQhTUzsU2levj4d+Lc8H3rCU4=
Date: Sun, 3 Feb 2008 12:36:17 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 23/32] ide-tape: struct idetape_tape_t: shorten member
	names
Message-ID: <20080203113617.GB5268@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-18-git-send-email-petkovbb@gmail.com> <200802030043.23110.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802030043.23110.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 12:43:22AM +0100, Bartlomiej Zolnierkiewicz wrote:

Hi,

[...]

> Even if this patch contains only trivial changes, the amount of them
> and the fact that it intermixes different logical changes (shortening
> names, dead code removal and comments beautification) makes it somehow
> non-trivial to review.
> 
> General comment:
> please have some mercy on the reviewer (in this case me ;) and spread
> the changes across more patches (it should also be easier for you since
> with more patches it is more likely that the more changes get applied
> the first time and you will have less code to recast/resubmit).
>

sorry about that, i tend to forget myself sometimes when going over the code and
wanting to fix all in one go. Concerning the shortening of the variable names -
i wanted to make them as short as possible so that i have less lines > 80 and
not have to break them and make them less readable. Will redo.

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
