Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbYKMPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbYKMPsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYKMPrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:47:49 -0500
Received: from isilmar.linta.de ([213.133.102.198]:45087 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbYKMPrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:47:49 -0500
Date: Thu, 13 Nov 2008 16:45:38 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Julia Lawall <julia@diku.dk>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/pcmcia/cistpl.c: introduce missing braces
Message-ID: <20081113154538.GB7264@comet.dominikbrodowski.net>
Mail-Followup-To: Julia Lawall <julia@diku.dk>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0811131133010.9563@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811131133010.9563@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 13, 2008 at 11:33:54AM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The indentation and behavior of the code below suggests that braces are
> intended around the if branch.

good catch, but already fixed in pcmcia-git and on its way to Linux (commit
e689597fe890cf22e23195037aa668c39b25ae4b ) -- many thanks nonetheless!

BTW: is this an automatic test script of some sort? if so, it might be
useful to run this on linux-next kernels, too, so that bugs like this one
are caught before they hit mainline.

Best,
	Dominik
