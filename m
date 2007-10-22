Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbXJVPXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbXJVPXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXJVPXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:23:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:23208 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbXJVPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c8pGZpxmj9RgLxbSBRLJQxbGi3DN3jjXh6JDwYea5ndMwY4g7GNYnJ169KHx4Seg+OWWDSgntriKuaSqRi9LT+i4X5XT0LqS3A1zeJisPpdk1BSjmSHO0H3GGMcLzptf0Y0mKipqR0DwC3fOtpdYWUgqRI0K5U5j/e7COL7z2x8=
Message-ID: <84144f020710220823r258d6401t634bfbe130b43413@mail.gmail.com>
Date: Mon, 22 Oct 2007 18:23:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] return hidden bug
Cc: "Roel Kluin" <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071022111904.72f54ab9@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471BF741.2020501@tiscali.nl>
	 <20071021214209.1a7567d7@bree.surriel.com>
	 <84144f020710220230t24d95470o7cabec4450e68814@mail.gmail.com>
	 <20071022111904.72f54ab9@bree.surriel.com>
X-Google-Sender-Auth: 8f1673491b872c1f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On 10/22/07, Rik van Riel <riel@redhat.com> wrote:
> On Mon, 22 Oct 2007 12:30:00 +0300
> I guess people who disable CONFIG_BUG really choose to shoot themselves
> in the foot when something bad happens.  The kernel is full of error
> paths where the current thread really should not be continuing.

Sure, if you disable BUG_ON, it may or may not work. But making it
*worse* on purpose seems pointless.
