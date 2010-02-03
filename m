Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0BCBx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:53:56 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:40388 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0BCBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HBcjo65tIasyJiSXw2oXbW/p2pc+x5ttblsgkXoDdgZFB4Q1DFq0g3upMoV71JIRZS
         8IklV9b564KwukQwKPlMjTGQc3vphnGW/CcgvGwTInsCIG3K+6qabE4cwru4iBNDrjqH
         8/iFdJ0FFht7ZkLRbaEWXnIEbMeHut9vQxZoQ=
Date: Tue, 2 Feb 2010 17:53:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bob Rodgers <Robert_Rodgers@dell.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
       rpurdie@rpsys.net
Subject: Re: Re: [RFC] Dell activity led WMI driver
Message-ID: <20100203015341.GA21173@core.coreip.homeip.net>
References: <4B6898AF.5060703@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6898AF.5060703@dell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

On Tue, Feb 02, 2010 at 03:27:11PM -0600, Bob Rodgers wrote:
> 
> static int __init dell_led_probe(struct platform_device *pdev)
> {

This should either be changed to __devinit or you need to call
platform_device_probe() or, even better, use platform_create_bundle()
that is in next.

But isn't it a bit wasteful to create a brand new platform device only
to attach a single led device to it? I think that, even thourgh LED GUID
is separate, it would be better to keep all this functionality in
dell-wmi driver.

Thanks.

-- 
Dmitry
