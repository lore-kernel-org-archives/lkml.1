Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYKNTk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYKNTk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYKNTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:40:51 -0500
Received: from h155.mvista.com ([63.81.120.155]:4162 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751259AbYKNTku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:40:50 -0500
Message-ID: <491DD440.9000402@ru.mvista.com>
Date: Fri, 14 Nov 2008 22:40:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>, Greg KH <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
References: <20081113230259.GA3681@kroah.com> <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com> <20081114191545.GA24115@kroah.com>
In-Reply-To: <20081114191545.GA24115@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Greg KH wrote:

>>Hi Greg,

>>There is a difference in the musb patch I submitted and the one which actually has been
>>forwarded to you by Felipe. This difference has introduced a bug.

>>The patch in you series is,
>>usb: musb: fix BULK request on different available endpoints

>>It was submitted by me at,
>>http://marc.info/?l=linux-usb&m=122337227617797&w=2

>>And the one which is forwarded to you by Felipe is at,
>>http://marc.info/?l=linux-usb&m=122528597316728&w=2

>>There is a difference in between above two as below.
>>Original: +	if (best_end < 0 && qh->type == USB_ENDPOINT_XFER_BULK) {
>>Sent to you: +	if (best_end > 0 && qh->type == USB_ENDPOINT_XFER_BULK) {

>>It should be [best_end < 0].

>>If it is possible then please correct this mismatch in your series.

> I'll wait to get a patch from Felipe for this.

    I'm seeing it being to you sent at least a week ago -- look for "usb: 
musb: fix bug in musb_schedule".

> thanks,
> greg k-h

WBR, Sergei
