Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYFVPV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYFVPV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 11:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYFVPVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 11:21:20 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:28476 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYFVPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 11:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UvzChO/cQArI8AeJm90BN1JXjP1zXVzHu7NGJ62KAe3f3APPPx20J1nwPlk9n7IJyq
         TXJi7Z8fpN5v0P2XQw7ZK9UwjN/ESIpb1ZL/HDfkFlZdLAo2w9wax9W93Isg+EVpRo9T
         l9b/IoNq7RhUBh7WAI+ShdjvRQK0CcUN+uJ0o=
Date: Sun, 22 Jun 2008 19:21:09 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] Add support for power_supply on tosa
Message-ID: <20080622152109.GA14117@doriath.ww600.siemens.net>
References: <20080620084917.GA20577@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620084917.GA20577@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 12:49:17PM +0400, Dmitry Baryshkov wrote:
> Support the battery management on Sharp Zaurus SL-6000.
> 
> This patch depends on the tc6393xb support as found in the arm:devel
> or linux-next trees.
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/power/Kconfig        |    7 +
>  drivers/power/Makefile       |    1 +
>  drivers/power/tosa_battery.c |  485 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 493 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/tosa_battery.c

Any comments on this? As this driver is protected by necessary
dependencies in Kconfig, it can be merged even now.

-- 
With best wishes
Dmitry

