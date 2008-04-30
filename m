Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbYD3TuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbYD3TuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932828AbYD3Ttn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:49:43 -0400
Received: from 1wt.eu ([62.212.114.60]:3618 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbYD3Ttm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:49:42 -0400
Date: Wed, 30 Apr 2008 21:49:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080430194920.GD7501@1wt.eu>
References: <20080430000851.GH4818@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430000851.GH4818@implementation>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 01:08:51AM +0100, Samuel Thibault wrote:
> Willy Tarreau wrote:
> > 3) if I enter Alt-196, I get a "Ä". Flushing the buffer shows that od
> > got two bytes: c3 84.
> 
> Confirmed.
> 
> Try init=/bin/stty -a, that will show
> 
> -iutf8
> 
> So there is little wonder that canonical mode does not work as expected.
> 
> Try init=/bin/sh, from that shell run stty iutf8. Then things will work
> fine.  The fix is thus just to make the VT's tty initial iutf8 setup
> follow vt.default_utf8.

Will try that on a more recent install. Mine's stty does not support
this option. Your analysis makes quite a lot of sense, and such a fix
would wipe part of my annoyances/anger with this recent change.

Thanks,
Willy

