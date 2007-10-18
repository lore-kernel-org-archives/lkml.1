Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbXJRLB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbXJRLB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbXJRLBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:01:46 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:48597 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004AbXJRLBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:01:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [2.6 patch] USB iowarrior.c: fix check-after-use
Date: Thu, 18 Oct 2007 13:01:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org
References: <20071018105250.GM3778@stusta.de>
In-Reply-To: <20071018105250.GM3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181301.56572.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 18 Oktober 2007 schrieb Adrian Bunk:
> The Coverity checker spotted that we have already oops'ed if "dev"
> was NULL.
> 
> Since "dev" being NULL doesn't seem to be possible here this patch 
> removes the NULL check.

Looking good.

	Regards
		Oliver

