Return-Path: <linux-kernel-owner+w=401wt.eu-S1764361AbYJJUpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764361AbYJJUpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764164AbYJJUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:44:57 -0400
Received: from kroah.org ([198.145.64.141]:55120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764161AbYJJUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:44:56 -0400
Date: Fri, 10 Oct 2008 13:41:33 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010204133.GB32357@kroah.com>
References: <48EFB4B2.2020508@canonical.com> <20081010201805.GC32164@kroah.com> <48EFBCA4.6020008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EFBCA4.6020008@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 01:35:48PM -0700, H. Peter Anvin wrote:
> Greg KH wrote:
>> Is there a problem with being assigned to IRQ0 in situations like this?
>
> On PCs, IRQ 0 is dedicated to use for the PIT.

Ah, I didn't realize it couldn't be shared.

thanks,

greg k-h
