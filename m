Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYHIWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYHIWFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYHIWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:04:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbYHIWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:04:50 -0400
Date: Sat, 9 Aug 2008 16:04:22 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [00/03] [RFC] USB debugging rework
Message-Id: <20080809160422.48eae96b.zaitcev@redhat.com>
In-Reply-To: <20080809013820.GA10910@kroah.com>
References: <20080809013820.GA10910@kroah.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 18:38:21 -0700, Greg KH <greg@kroah.com> wrote:

> I've been annoyed for a long time that we make users go off and rebuild
> their kernels just to enable usb debug messages.  So finally, here's the
> start of fixing that issue.

In many cases usbmon does the job, and it's intended to be "always-on",
as to allow building it even on embedded kernels. Sure, it will not print
nice values of quirks and such, but that's a trade-off. I sort of hoped
that the switcheable explicit messages would generally die off. Look
at ub, it only has messages which indicate error conditions.

I'm not against your patch as such, it's a net improvement.

-- Pete
