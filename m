Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbYDTL5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbYDTL5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYDTL50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:57:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYDTL50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=g+1zy3JzXsJnpwgDJgCIoUhTP5yZ2OQbqwfSKt9J2H5HFb2zBFH0RjIVLpf6rmpjA43DfFd2Hkagito6ufSV+P8nukSAeGvBn979/z8DywaHop9IppvMUl8zmeoaz1omnW/vpVyGLRLMYy/5ahdVH2JGQHTbR34ja3XBELRqrs8=
Message-ID: <480B2F9A.3020104@gmail.com>
Date: Sun, 20 Apr 2008 13:57:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, mit-devel@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: HID bus
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1208644696-29129-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2008 12:38 AM, Jiri Slaby wrote:
> Now, I wonder for exactly what purpose are module.*map files in
> /lib/modules/`uname -r`/ dir, i.e. what would break, if the devices won't
> be listed there on systems with unpatched module-init-tools.

Well, used by /sbin/hotplug. I.e. on systems which uses that hotplugging system 
and not new enough udev. It means older RHEL, SLE* et al., and older 
distributions too...

So I suppose we still need the option to let users compile all the chosen 
drivers into hid.
