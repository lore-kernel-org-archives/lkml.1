Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYINPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYINPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYINPQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:16:50 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37631 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYINPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bQCRMPyYJEALk7kvNr+eL3FnAr9CVGE7zs5SjSgha7yO/7VFlFY2YYe/ibWGqQOk1o
         J+j5nNpNDKOwuyhNfiLbHLF/bPn9g1eQu7cRAcGHmQSigmtkkJVK6GqziH/9s2PfFynV
         YWUc7/cqjpjxT8PGOUfAyS5vMygiHuZN5IF4s=
Date: Sun, 14 Sep 2008 11:16:41 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Henk.Vergonet@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH resend] input: Move map_to_7segment.h to include/linux
Message-ID: <20080914151639.GA5391@amd.corenet.prb>
References: <20080914.223032.48797005.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914.223032.48797005.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Atsushi,

On Sun, Sep 14, 2008 at 10:30:32PM +0900, Atsushi Nemoto wrote:
> The map_to_7segment.h provides generic 7segment LED mappings and is
> designed to be used by other drivers.  Moving it to common area will
> make it more usable.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Henk Vergonet <henk.vergonet@gmail.com>

Should we also export this header to userspace and install it with other
kernel headers?

-- 
Dmitry
