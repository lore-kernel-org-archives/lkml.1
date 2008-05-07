Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbYEGPZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbYEGPZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYEGPZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:25:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52816 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbYEGPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:25:35 -0400
Date: Wed, 7 May 2008 09:25:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: rae l <crquan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: It's time to hack on dentry_stat?
Message-ID: <20080507152533.GW19219@parisc-linux.org>
References: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com> <20080507145116.GV19219@parisc-linux.org> <2c0942db0805070808t663eafffic5e78c9d1ba8bc68@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0805070808t663eafffic5e78c9d1ba8bc68@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 08:08:09AM -0700, Ray Lee wrote:
> One could hardcode the output of the last three (four?) fields, yes?
> Slightly grotty, but if it comes with a decent memory savings...

How can it be a 'decent memory saving'?  There is exactly _one_ struct
dentry_stat_t in the entire kernel.  So you're talking about saving 4
ints, or 16 bytes.  Bet you it'd be more bytes to hardcode printing zero.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
