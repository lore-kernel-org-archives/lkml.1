Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbYFPWwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbYFPWwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYFPWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:52:24 -0400
Received: from gw.goop.org ([64.81.55.164]:49480 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575AbYFPWwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:52:24 -0400
Message-ID: <4856EE79.1000205@goop.org>
Date: Mon, 16 Jun 2008 15:51:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2/2] xen: don't drop NX bit
References: <4856E2D4.3020402@goop.org> <20080616223508.GA1165@kroah.com>
In-Reply-To: <20080616223508.GA1165@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> While it's great that you tell the stable people about this, but is it
> realistic?  Is anyone using Xen as contained in the mainline kernel
> these days?
>   

Yes, it's what Redhat is shipping in Fedora 9.

> If a distro were to be based on 2.6.25 and we take this patch, they will
> just revert it back out due to their very large Xen patchset they apply
> on top to get a "working" Xen version, right?
>   

No.  RH is using upstream Xen now.  I don't know what the other distros 
are doing, but Novell is considering it, at least.

    J
