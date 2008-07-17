Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYGQWRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYGQWRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYGQWRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:17:10 -0400
Received: from xes-mad.com ([216.165.139.214]:49431 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYGQWRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:17:09 -0400
X-Greylist: delayed 2500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 18:17:08 EDT
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
From: Nate Case <ncase@xes-inc.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20080715151917.GA30607@polina.dev.rtsoft.ru>
References: <1216133032.5345.73.camel@dax.rpnet.com>
	 <20080715151917.GA30607@polina.dev.rtsoft.ru>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 16:29:01 -0500
Message-Id: <1216330141.7559.950.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 19:19 +0400, Anton Vorontsov wrote:
> +       led->cdev.name = of_get_property(np, "label", NULL);
> +       if (!led->cdev.name)
> +               led->cdev.name = dev_name(&ofdev->dev);

How about also supporting a "trigger" property which would set
cdev.default_trigger in the same manner?  It would be useful for boards
to be able to specify this in the device tree (e.g., if a certain LED is
meant to be used as a "heartbeat").

-- 
Nate Case <ncase@xes-inc.com>

