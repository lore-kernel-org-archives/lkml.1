Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbYD3TrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbYD3TrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbYD3Tqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:46:47 -0400
Received: from 1wt.eu ([62.212.114.60]:3616 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764367AbYD3Tqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:46:46 -0400
Date: Wed, 30 Apr 2008 21:45:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, cmadams@hiwaay.net,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080430194532.GC7501@1wt.eu>
References: <20080430000851.GH4818@implementation> <20080430093831.GD4443@implementation.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430093831.GD4443@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:38:32AM +0100, Samuel Thibault wrote:
> Chris Adams wrote:
> > Once upon a time, Samuel Thibault  <samuel.thibault@ens-lyon.org> said:
> > >Try init=/bin/sh, from that shell run stty iutf8. Then things will work
> > >fine.  The fix is thus just to make the VT's tty initial iutf8 setup
> > >follow vt.default_utf8.
> > 
> > You may also need to select a UTF-8 locale (e.g. LANG="en_US.UTF-8") for
> > programs like bash to handle this correctly.
> 
> Yes of course, but here the purpose was _not_ programs like bash, but
> the canonical mode (i.e. programs like cat etc.), for which the LANG
> variable has no effect, only iutf8 has.

exactly, thanks for understanding my problem Samuel :-)

Willy
