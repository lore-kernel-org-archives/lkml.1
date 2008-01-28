Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbYA1PAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbYA1PAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYA1PAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:00:22 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40824 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYA1PAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:00:22 -0500
Message-ID: <479DEE10.6060203@keyaccess.nl>
Date: Mon, 28 Jan 2008 16:00:32 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc	-	working
 version
References: <1200772810.3708.42.camel@queen>	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>	 <1201109917.20940.214.camel@queen.suse.de>  <479CD935.3070906@keyaccess.nl> <1201530103.20940.413.camel@queen.suse.de>
In-Reply-To: <1201530103.20940.413.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-01-08 15:21, Thomas Renninger wrote:

> I think I know what is going on.
> While pnpbios and pnpacpi theoretically do not have limits, isapnp has
> spec restrictions (AFAIK, I have not read this up, but taken over from
> previous implementation...).
> Therefore in isapnp I wanted to stay with:
> #define PNP_MAX_PORT            8
> #define PNP_MAX_MEM             4
> #define PNP_MAX_IRQ             2
> #define PNP_MAX_DMA             2
> but I have forgotten to malloc one portion for each at init time, or
> even better one portion as soon as one is needed.

Yup.

> As said, isapnp is more or less untested, thanks a lot for trying out.
> I will send an updated version soon.

I"m not sure of the flow of things by the way but if it makes better/nicer 
code to just pretend that ISAPnP is also unlimited then I'd say to simply do 
so. ISAPnP is getting obsolete anyway, not anything to optimise for...

Rene.
