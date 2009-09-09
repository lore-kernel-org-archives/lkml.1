Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZIIRTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZIIRTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZIIRTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:19:50 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:55516 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZIIRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:19:49 -0400
X-Greylist: delayed 1850 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 13:19:49 EDT
Date: Wed, 9 Sep 2009 18:49:12 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Martin <pm@debian.org>
Message-ID: <20090909164912.GD4992@dodger.lab.datenfreihafen.org>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
 <Vm51Upp4EV.A.yPC.KfBpKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Vm51Upp4EV.A.yPC.KfBpKB@chimera>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: [Bug #14103] cdc_acm gives I/O error
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sun, 2009-09-06 at 19:24, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14103
> Subject		: cdc_acm gives I/O error
> Submitter	: Paul Martin <pm@debian.org>
> Date		: 2009-09-01 13:30 (6 days old)
> Handled-By	: Oliver Neukum <oliver@neukum.org>

I had the same problem here at least since -rc4. Oliver already did a two-liner
patch to fix the issue. Can be found here:

http://bugzilla.kernel.org/attachment.cgi?id=23046

It fixes the issue for me on two different cdc_acm devices. Don't know if it is
already in the USB tre, but I had to apply it to linus HEAD from today. Would
be good to get this in before the -final as it would cause a real regression.

regards
Stefan Schmidt
