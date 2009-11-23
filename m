Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZKWQcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZKWQcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZKWQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:32:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58288 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZKWQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WRjOfHjoeR+zhv/4AfvTIhqAWg49vcWWGKwstr5LNSFsUrQyAMCwhxIs7MlPR1+BR9
         9a990lUFPMHFWbLAilhkl8nYtP4a77impf9ovHPEMPWfCOj823zbxpA11gpEgmCwB5Kn
         fljD7RxwO24PlUbQSJ+IKmatGWPREmDGQtPAk=
Date: Mon, 23 Nov 2009 08:32:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091123163211.GB3491@core.coreip.homeip.net>
References: <20091123143503.3cdf8dee.sfr@canb.auug.org.au> <20091123122606.GA3616@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123122606.GA3616@sortiz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Mon, Nov 23, 2009 at 01:26:07PM +0100, Samuel Ortiz wrote:
> Hi Dmitry,
> 
> On Mon, Nov 23, 2009 at 02:35:03PM +1100, Stephen Rothwell wrote:
> > Hi Samuel,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > drivers/power/pcf50633-charger.c: In function 'pcf50633_mbc_get_usb_online_status':
> > drivers/power/pcf50633-charger.c:147: error: 'struct pcf50633' has no member named 'mbc_pdev'
> > 
> > Caused by commit 4c2e3bacc050f0ebf884954bb007616c162564cd ("mfd: pcf50633
> > - fix error handling during probe") from the mfd tree interacting with
> > commit c329795052aa339850a45fab649ab97a36905136 ("pcf50633: Query charger
> > status directly") from the battery tree.
> Could we split the above fix so that we get back to the:
> 
> 	struct platform_device *rtc_pdev;
> 	struct platform_device *mbc_pdev;
> 	struct platform_device *adc_pdev;
> 	struct platform_device *input_pdev;
> 	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];
> 
> structure ? We can move to the index based structure after the next merge
> window. That would make my life easier in terms of tree dependencies.
> If you dont have time to do this change, I'll do it some time this week.
> 

Please feel free to drop or reschedule the patch as you see fit. I don't
have any problem if it will go in later.

Thanks.

-- 
Dmitry
