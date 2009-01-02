Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbZABO2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbZABO2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZABO2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:28:37 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:29326 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbZABO2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=F6l3UIq0RrUtp/aKjHMrPGoIyd4lf0+k1oIQn1MuPjS9tYA0FUqm22LeohSlCG4Wva
         NEZwY7sUa+T0Sz7TnH1AZCpbVFWgQKJ5gEh+kT9HR3qOaNnskYq0txp2Rw9Tmua7qkkE
         1S3IB5vEORjNrN9s4CLA0CS+z/A0wKPqU4xOY=
Date: Fri, 2 Jan 2009 22:28:28 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090102142828.GD4833@thyme.bj.intel.com>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <20090102095643.GB17103@x61> <20090102140023.GC4833@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102140023.GC4833@thyme.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:00:23PM +0800, Yan Li wrote:
> Now I know 3 methods supposed can be used to shut the device:
> 1. (Alan Stern said Windows use this) cut the USB port's power
> 2. send STOP SCSI command to stop it
> 3. put it into suspend mode
> 
> For the 1st method I have no much experience with Windows so I can't
> verify. But now I doubt it. Since there are many early USB devices
> that still show light on after you "safely remove" it from Windows. I
> guess the power is still supplied but the device is send a command to
> be shutdown or suspended.

Sorry, Alan have not said `cut the power'. He said `disable the port'.

-- 
Li, Yan
