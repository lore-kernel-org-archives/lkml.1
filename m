Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051Ab0AGXSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0AGXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906Ab0AGXSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:18:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0AGXSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:18:21 -0500
Subject: Re: [PATCH] x86: allow fbdev primary video code on 64-bit.
From: Dave Airlie <airlied@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B4668F7.1000304@zytor.com>
References: <1262847894-27498-1-git-send-email-airlied@gmail.com>
	 <4B4668F7.1000304@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 09:15:16 +1000
Message-Id: <1262906116.25818.19.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 15:06 -0800, H. Peter Anvin wrote:
> On 01/06/2010 11:04 PM, Dave Airlie wrote:
> > From: Dave Airlie <airlied@redhat.com>
> > 
> > For some reason the 64-bit tree was doing this differently and
> > I can't see why it would need to.
> > 
> > This correct behaviour when you have two GPUs plugged in and
> > 32-bit put the console in one place and 64-bit in another.
> > 
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> Looks good... I presume this is for .34, though?

I don't mind, I'll be putting it into Fedora kernel anyways
since its a real bug when the console turns up different on
the same machine with 32 vs 64-bit kernels.

I can't see it having any side effects, not many ppl
run two fbs on x86 anyways yet.

Dave.


