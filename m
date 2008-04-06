Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYDFCzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYDFCzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 22:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYDFCy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 22:54:57 -0400
Received: from ozlabs.org ([203.10.76.45]:48785 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYDFCy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 22:54:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH RFC 2/5] vringfd base/offset
Date: Sun, 6 Apr 2008 12:54:32 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
References: <200804052202.09157.rusty@rustcorp.com.au> <200804052204.28518.rusty@rustcorp.com.au> <47F77431.3030608@qumranet.com>
In-Reply-To: <47F77431.3030608@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804061254.33153.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 April 2008 22:44:33 Avi Kivity wrote:
> Rusty Russell wrote:
> > It turns out the lguest (and possibly kvm) want the addresses in the
> > ring buffer to only cover a certain part of memory, and be offset.
> >
> >  					<mailto:rusty@rustcorp.com.au>
> > +0xAE	00-01	linux/vring.h
>
> Another virtualization subsystem already uses this range.

Nasty.  Not listed in the ioctl list, and didn't find it with grep 8(.  I 
don't think I ever used 0xAD which was assigned to me, so I can change to 
that.

Thanks,
Rusty.
