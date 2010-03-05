Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0CECA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:00:28 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:48191 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0CECA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p5LRiVS2bOuCgsoU8qYNBhfz90tuKPOAoWHgrsHanAnVXc+ty2Sl1QWOQ+M8Xozt/F
         BXaV7zdXCrQvFvvU4OIiqB87sUAik7WEaf4ivnQ3T/rvma0I/4fc7DRqKnByXeV7dNA/
         a0j92oGy6F7VDI6mWJm354cr4aOWKMew/RM44=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <20100304105624.70fe845e@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	 <1267748927.3496.6.camel@nisroch>
	 <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
Date: Thu, 4 Mar 2010 18:00:25 -0800
Message-ID: <12c511ca1003041800p743b22e9pe80de18701b6e271@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 4:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> And if we end up having people bisecting back and forth, I will hate that
> f*cking nouveau driver even more.

Would it help to tag the flag day commit? At least that would make it
trivial for bisecters to see whether each step in a bisection contains
the commit or not.

Generalizing that ... perhaps there could be a way to tell git that some
set of tags represent flag days, so it could warn in any bisection if the
set of included flag days changes.

-Tony
