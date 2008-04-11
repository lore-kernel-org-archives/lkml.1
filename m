Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbYDKIZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbYDKIZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYDKIZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:25:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:32716 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbYDKIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=glOuph+rMilAT7hGhKqHIqNGpevJ9825Z0d++a3YtWpEOhu2TvdOcMNQ+t9lCzB1rPeEQVGex0pufuhjC9Mjv/ZIrgRYcc/NyQNUvKQdOjT1/8RRc6H4frFGoFnO034DTZ7pe1gk3q7f2hLuU+//vkg+ad5TRle63EuUaRqzboU=
Message-ID: <3d8471ca0804110125r1b4e97c0ua419587a64c9b1c7@mail.gmail.com>
Date: Fri, 11 Apr 2008 10:25:09 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: set_cyc2ns_scale() remove tsc_now and ns_now
Cc: "Ingo Molnar" <mingo@elte.hu>, "Karsten Wiese" <fzu@wemgehoertderstaat.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080411080617.GP10019@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102331.11815.fzu@wemgehoertderstaat.de>
	 <873apsn8g7.fsf@basil.nowhere.org> <20080411075554.GA6834@elte.hu>
	 <20080411080617.GP10019@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 10:06 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  At some point you have to generate an offset to something and that
>  offset must be different for different frequencies, otherwise
>  you get large systematic errors

This offset is already there, represented by rq->clock - sched_clock()

-- 
Guillaume
