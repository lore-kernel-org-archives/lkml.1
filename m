Return-Path: <linux-kernel-owner+w=401wt.eu-S1763735AbXJRLBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763735AbXJRLBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXJRLBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:01:23 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:48501 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXJRLBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:01:22 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [2.6 patch] USB rio500.c: fix check-after-use
Date: Thu, 18 Oct 2007 13:01:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, miquel@df.uba.ar, greg@kroah.com,
       rio500-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20071018105307.GN3778@stusta.de>
In-Reply-To: <20071018105307.GN3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181301.29880.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 18 Oktober 2007 schrieb Adrian Bunk:
> The Coverity checker spotted that we have already oops'ed if "dev"
> was NULL in these places.
> 
> Since "dev" being NULL isn't possible at these places this patch removes 
> the NULL checks.

Looking good.

	Regards
		Oliver
