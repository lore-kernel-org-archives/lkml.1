Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXC0FAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXC0FAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXC0FAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:00:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60824 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbXC0FAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:00:42 -0400
Message-ID: <4608A4F4.1010208@garzik.org>
Date: Tue, 27 Mar 2007 01:00:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070323205652.GA9965@srcf.ucam.org>
In-Reply-To: <20070323205652.GA9965@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Mar 23, 2007 at 07:13:21PM +0000, Alan Cox wrote:
>> +static int ata_ignore_hpa = 0;
>> +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
>> +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");
> 
> I'm not sure I like the language here. "Ignore HPA" appears to mean 
> "Explicitly disable the HPA", which I guess is one interpretation of 
> "ignore" - however, naively I'd expect "Ignore HPA" to mean "Don't touch 
> the HPA" with the result that it would remain inaccessible to userspace.

"ignore" sounds more appropriate to me.

We're not just making it inaccessible, we are actively ignoring all 
traces of its existence everywhere, when that setting is enabled.

	Jeff



