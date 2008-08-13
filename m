Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYHMTsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYHMTsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYHMTsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:48:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:63957 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHMTsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GsrYBn1vLNjKVsLUJXyYj8hC8R4CuRuqsUMQimN3luSpPaUpkGSHDs7O0n5GZWeXzF
         1Rgm4+I0t0ysyLBCCPkjLmcPmIsWC7yPVIfYSz5gHx6W71o33pfNPTpa1U9zVS+BnPn2
         zWkNm7ZLvaUbegdYHm9+e6SkpFdkjUAjme8Lw=
Message-ID: <ea8d860a0808131248g31ffb10g37b14dc8af89038c@mail.gmail.com>
Date: Wed, 13 Aug 2008 20:48:19 +0100
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Intel Management Engine Interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080813181850.GD4886@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl>
	 <20080813005835.GE22793@kroah.com>
	 <ea8d860a0808130016w646307few3cc6385caf9b1ec7@mail.gmail.com>
	 <20080813181850.GD4886@kroah.com>
X-Google-Sender-Auth: 9f8cdefdc17241de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/13 Greg KH <greg@kroah.com>:
>> GET_VERSION is called frequently
>
> Why?  Shouldn't it only be called once?
Once per connection. But you can have many clients connecting.

>> With ioctl - only one file handle is used, and userspace client logic
>> is simpler.
>
> But the kernel is messier and we are trying to not add any more ioctls
> to it.  Especially for trivial things like the version number of the
> hardware device.
It's rather protocol version (=running software version) supported by
hardware device.
Hmmm, I just didn't know that there is something wrong with ioctls.

>> Normal flow looks like:
>>
>> open
>> ioctl(GET_VERSION)
>
> Great, do an additional open/read/close here for the version, I think
> you will find it pretty trivial to do :)
Right, it's trivial.... but will make userspace source code messier and bigger.

Btw. I know we have powerful CPUs... but small wasting resources is
still wasting resources... so we still need new CPUs :-).

Regards
Marcin
