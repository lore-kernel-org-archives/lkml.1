Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYEDLE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYEDLE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYEDLET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:04:19 -0400
Received: from 1wt.eu ([62.212.114.60]:4099 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYEDLET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:04:19 -0400
Date: Sun, 4 May 2008 13:03:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: Re: Fix VT canonical input in UTF-8 mode [Was: UTF-8 fixes in comments]
Message-ID: <20080504110348.GA3334@1wt.eu>
References: <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation> <20080504085514.GA27263@1wt.eu> <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation> <20080504102554.GA4729@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080504102554.GA4729@implementation>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 11:25:54AM +0100, Samuel Thibault wrote:
> Willy Tarreau, le Sun 04 May 2008 10:55:14 +0200, a écrit :
> > I confirm that your patch works perfectly for me. Now backspace correctly
> > removes multi-byte characters. My bash is still fooled though but as Alan
> > explained it, it's readline which has to be upgraded now.
> 
> I guess this is suitable for the stable trees of 2.6.24 and 2.6.25
> (where UTF-8 is by default now).

agreed.

> Set IUTF8 as appropriate on VT tty open.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

You should have added:  CC: stable@kernel.org here so that the stable
team automatically gets notified when it's merged into mainline.

Thanks!
Willy

