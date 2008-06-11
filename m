Return-Path: <linux-kernel-owner+w=401wt.eu-S1764922AbYFKRoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764922AbYFKRoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763656AbYFKRop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:44:45 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:42318 "EHLO
	vigor.karmaclothing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYFKRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:44:44 -0400
Date: Wed, 11 Jun 2008 18:44:15 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [MIPS] The tickcount per-cpu variable can become
	static
Message-ID: <20080611174415.GE30400@linux-mips.org>
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi> <12120730321843-git-send-email-dmitri.vorobiev@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12120730321843-git-send-email-dmitri.vorobiev@movial.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 05:57:12PM +0300, Dmitri Vorobiev wrote:

> In arch/mips/mips-boards/generic/time.c, the `tickcount' per-cpu
> variable is needlessly defined global, and this patch makes it
> static.
> 
> Noticed by sparse. Tested by booting a Qemu-emulated Malta board
> up to the shell prompt.

Patch is ok - except it tries to fix a piece of code which I've already
removed so I'll drop this one.

  Ralf
