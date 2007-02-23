Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbXBWH4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbXBWH4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 02:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXBWH4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 02:56:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:25213 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXBWH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 02:56:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gNTaNQAC78da1vOXDO/+NeoOiVRnLTNqxCnDg4AZy1uqMIzeoMEmlya9GwKOkyJlI9j9GNbYtlGFolpDvQxw7w578Lim1GcUttzlvcIPvFqwgi4/Wn+XKY73hH64L5GgOH7i5wQ7PKFFgkY3TJFVsPwzfiy2BT/+/sMYXvWcz4o=
Date: Fri, 23 Feb 2007 10:53:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation
Message-ID: <20070223075322.GA10055@cvg>
References: <20070219181549.GB10111@cvg> <20070222155523.53e649a3.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222155523.53e649a3.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 03:55:23PM -0800, Pete Zaitcev wrote:
| On Mon, 19 Feb 2007 21:15:49 +0300, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > +++ b/drivers/usb/misc/ftdi-elan.c
| > @@ -57,9 +57,9 @@ module_param(distrust_firmware, bool, 0);
| >  MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overcurren"
| >          "t setup");
| >  extern struct platform_driver u132_platform_driver;
| > -static struct workqueue_struct *status_queue;
| > +static struct workqueue_struct *status_queue = NULL;
| 
| You better drop this part. Someone is bound to object.
| 
| -- Pete
| 

Hi,

actually I don't understand why... Event on ftdi_elan_exit()
status_queue is setting up to NULL. And what is bound to object?
Could you write more detailed?

		Cyrill

