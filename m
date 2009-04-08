Return-Path: <linux-kernel-owner+w=401wt.eu-S934294AbZDHQ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294AbZDHQ4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZDHQ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:56:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35802 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZDHQ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UE+ah1LEyvvN2lNKmIqRvnnfV6rMPyPiVWfTMXDZTJex9FP8YP7ultLudHKkAEwJAu
         HnG3y7k5z3DQxmktNEL+h/7j5xDo0w1IvJfNOCcBL1hSptzIQL/0J0a3659tVQU0pBUS
         nvQIKx5RFx/8NwWZV6bLHDiz/H4Z6z1iKKl/0=
Message-ID: <49DCD738.1080002@tuffmail.co.uk>
Date: Wed, 08 Apr 2009 17:56:24 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: usb-storage@lists.one-eyed-alien.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: usual_tables: module license 'unspecified' taints kernel.
References: <49DCD481.1050104@tuffmail.co.uk>
In-Reply-To: <49DCD481.1050104@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Hi, I see this regression in v2.6.30-rc1.  I end up with a module
> "usual_tables.ko", which is loaded on boot and causes the kernel to
> complain about an unspecified license.  See subject for the exact
> error message.
>
> I have
>
> CONFIG_USB_STORAGE=m
> CONFIG_USB_LIBUSUAL=y
>

> Also, usb-storage doesn't seem to get loaded automatically, as it did
> in 2.6.29 with the same configs.
>
Hmm, seems someone else broke request_module().  So don't worry about
this last issue - I'm sure it will get fixed :-).
