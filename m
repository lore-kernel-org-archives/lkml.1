Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZCFJpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZCFJpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCFJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:45:35 -0500
Received: from mail-qy0-f122.google.com ([209.85.221.122]:58128 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZCFJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:45:34 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2009 04:45:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NMm4lu6b3iaAvxAhPc/pHTz8My3Ozi8clI8ipTJlDyNb8bzu9E+aCLvlJognsmQG4e
         dBUIVRUQnHsvayLvyh7ZHPWriB4XDOZzSf3ftJLpKxivp8GlMchvdMqccOKw5rBiK1lD
         O7D5pOL6jeG2HTi3zN3t7Jn9bdoE8sage+smQ=
Date: Fri, 6 Mar 2009 01:38:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] Input: bf54x-keys: Fix typo
Message-ID: <20090306093642.GA24864@dtor-d630.eng.vmware.com>
References: <1236310491-24387-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236310491-24387-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Fri, Mar 06, 2009 at 11:34:51AM +0800, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/input/keyboard/bf54x-keys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
> index ee855c5..c6f4e16 100644
> --- a/drivers/input/keyboard/bf54x-keys.c
> +++ b/drivers/input/keyboard/bf54x-keys.c
> @@ -212,7 +212,7 @@ static int __devinit bfin_kpad_probe(struct platform_device *pdev)
>  	if (!pdata->debounce_time || pdata->debounce_time > MAX_MULT ||
>  	    !pdata->coldrive_time || pdata->coldrive_time > MAX_MULT) {
>  		printk(KERN_ERR DRV_NAME
> -			": Invalid Debounce/Columdrive Time from pdata\n");
> +			": Invalid Debounce/Columndrive Time from platform data\n");

Applied, but lowered severity form error to warning since the driver
is still functional even with bad timing values in platform data.

-- 
Dmitry
