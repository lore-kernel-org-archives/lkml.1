Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZJFFHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZJFFHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZJFFHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:07:04 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:42131 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbZJFFHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tqztpRaZcOOoBkf1h+GwLJO2Qmov+Fyqeblgp4EYYMHjh0hYn7NswmjHYHVLi7B4g6
         fyEX2KZ7fYzNQaK8XgGfBDrO9GjB5Ug6E1SH9JqBzc+156JGffsW829ZS0Mc88oKh3ua
         cL4lwrf1TxNeYVR+qcKAUFVStCTrA8FjyBAJI=
Date: Mon, 5 Oct 2009 22:06:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] Input: ad7879: pass up error codes from probe functions
Message-ID: <20091006050616.GD27881@core.coreip.homeip.net>
References: <1254633725-20479-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254633725-20479-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 01:22:05AM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> If the sub-probe functions fail, we need to pass up the error code to the
> higher levels from the probe function.  We currently always return 0 even
> if there was an error so higher levels don't report problems.
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thannk you Michael.

-- 
Dmitry
