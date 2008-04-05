Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbYDEIRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbYDEIRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 04:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYDEIRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 04:17:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:30726 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYDEIRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 04:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=vO2mFPrBI/addMKrUgM4Wpwe8N39kLXNBFYZkw65lZ9coKsnPgww6ifievzhzF9KUdGlGa2gEypuSu0xv6uTqtKI1ZhnD10pj1gUsCixwfsUkIrnbiR8vmLuvBhNWoPWzEWnWbu8BTaWTlWTHzGuR/5PCNF1sl2b5KofRT/UEbc=
Message-ID: <47F7359E.1020105@gmail.com>
Date: Sat, 05 Apr 2008 10:17:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was: 2.6.25-rc8-mm1]
References: <Pine.LNX.4.44L0.0804042331460.16995-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804042331460.16995-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2008 05:46 AM, Alan Stern wrote:
> Removing an interface's sysfs files before unregistering the interface
> doesn't work properly, because usb_unbind_interface() will reinstall
> altsetting 0 and thereby create new sysfs files.  This patch (as1074)
> removes the files after the unregistration is finished.  It's not
> quite as clean, but at least it works.
> 
> Also, there's no need to check if an interface has been registered
> before removing its sysfs files.  If it hasn't been registered then
> the files won't have been created, so usb_remove_sysfs_intf_files()
> will simply do nothing.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Tested-by: Jiri Slaby <jirislaby@gmail.com>

Works well, thanks.
