Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbXFRFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbXFRFzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbXFRFzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:55:37 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:45597 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXFRFzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=f76z2CyQ+Jvwkq2VVyqbZkrPfTwu/nuxiOmcrV+WfEmGKkQDYBIWsmVZbNbTwt/VV7rmx9xxo6meIyKs1kadxpob/xes4NRbFPqPbUtmOmrxvUu2QgDxGXj4RUrgqzyxejmoVAZ7CVjmWKSpoLcr7Y5/hWsjLtM/Jaospei2vpE=
Message-ID: <46761E52.4020701@gmail.com>
Date: Mon, 18 Jun 2007 14:55:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [2.6 patch] fix devres_release_all() return value
References: <20070617234254.GD3588@stusta.de>
In-Reply-To: <20070617234254.GD3588@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Every file should include the headers containing the prototypes for
> it's global functions.
> 
> Since the GNU C compiler is now able to detect that the function 
> prototype of devres_release_all() in the header and the actual function 
> disagree regarding the return value, this patch also fixes this bug.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Tejun Heo <htejun@gmail.com>

This should go through Greg.

  http://article.gmane.org/gmane.linux.kernel/544290/raw

-- 
tejun
