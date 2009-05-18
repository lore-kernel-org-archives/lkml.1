Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZERK37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZERK37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZERK3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:29:48 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:51009 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZERK3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:29:47 -0400
Subject: Re: [PATCH] regulator: da903x: add missing __devexit_p()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.miao@marvell.com>
In-Reply-To: <1242413433-26688-1-git-send-email-vapier@gentoo.org>
References: <1242413433-26688-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 11:29:45 +0100
Message-Id: <1242642585.5473.2157.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 14:50 -0400, Mike Frysinger wrote:
> The remove function uses __devexit, so the .remove assignment needs
> __devexit_p() to fix a build error with hotplug disabled.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Liam Girdwood <lrg@slimlogic.co.uk>
> CC: Mike Rapoport <mike@compulab.co.il>
> CC: Eric Miao <eric.miao@marvell.com>
> ---
>  drivers/regulator/da903x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Applied.

Thanks

Liam

