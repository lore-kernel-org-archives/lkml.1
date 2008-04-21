Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYDUPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYDUPjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYDUPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:39:17 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:19634 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486AbYDUPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=A46dHY8lPYWaYqj4C3KXIBBOPrs1IU/fo6o3XmJduW1mt2wiRtLdh+XFMY00opu7FAG6X72zpbJ4v0WM+JH0+kHXC5GmTR7bKyIoVZooF1kTI+wKkpLCniYCMx1O+MU/bJJ2vHGUg1QQCtTIzDBf0JpQ6heyHsWVpWJJ9kLaKiI=
Date: Mon, 21 Apr 2008 11:39:10 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH 29/37] Input: fix ordering in joystick Makefile
Message-ID: <20080421153910.GA6884@anvil.corenet.prv>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com> <20080421142245.GI6011@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421142245.GI6011@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:22:45PM +0300, Adrian Bunk wrote:
> On Mon, Mar 10, 2008 at 01:43:05PM +0100, Jiri Kosina wrote:
> > Make entries in drivers/input/joystick/Makefile properly alphabetically
> > ordered.
> 
> It also adds an entry for CONFIG_JOYSTICK_MAPLE?

Doh! Thank you for noticing, I will adjust it, maple is not quite there
yet.

> 
> BTW: The From: and To: headers in your emails were not correct.
> 

My fault. I was trying to use git-format-patch and formail and screwed
up. Why doesn't git-format-patch allow specify To: but only Cc:?

-- 
Dmitry
