Return-Path: <linux-kernel-owner+w=401wt.eu-S932746AbYDUNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbYDUNhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762008AbYDUNg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:36:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:58550 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762383AbYDUNgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aIC83bTZrTitP05xVESCVCt9Ctgg1qCQ8lR58zdtCc1jVyD52aeYumH/tfGmp/5rJHucpepgRWkpli0p5n1VA5ndSk+/erdgaESsil25Cjdf8cPrh26adNwUjo9bFRch2zoVsXxuQusWipLtShqWNPfHBcqtW2rOTMaAIQCbhns=
Date: Mon, 21 Apr 2008 09:36:21 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Anssi Hannula <anssi.hannula@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       mit-devel@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: HID bus
Message-ID: <20080421133621.GA27646@anvil.corenet.prv>
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com> <480B6C16.40806@gmail.com> <Pine.LNX.4.64.0804211124060.19002@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804211124060.19002@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:25:43AM +0200, Jiri Kosina wrote:
> On Sun, 20 Apr 2008, Anssi Hannula wrote:
> 
> > Why not just do something like
> > 
> > #define HID_DEVICE(vend, dev) \
> > 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
> > 		       USB_DEVICE_ID_MATCH_INT_CLASS, \
> > 	.idVendor = (vend), \
> > 	.idProduct = (prod), \
> > 	.bInterfaceClass = USB_INTERFACE_CLASS_HID
> > (see linux/usb.h)
> > 
> > and use USB hotplugging?
> > Or do we plan to match against something else as well, such as hid
> > reports or something?
> 
> No, we plan to do matching based solely on VID/PID. The report-specific 
> stuff is then handled between the specific driver and HID generic code.
> 

Hmm, [ab]using USB modalias makes me a bit uneasy. What about bluetooth
HID devices?

-- 
Dmitry
