Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYEOXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYEOXZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYEOXZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:25:28 -0400
Received: from ozlabs.org ([203.10.76.45]:53414 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYEOXZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:25:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
Date: Fri, 16 May 2008 09:25:17 +1000
User-Agent: KMail/1.9.9
Cc: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <1210865380.16012.15.camel@muff> <482C579F.4030509@qumranet.com>
In-Reply-To: <482C579F.4030509@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805160925.18087.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 01:32:47 Avi Kivity wrote:
> Mark McLoughlin wrote:
> > I think Rusty is speaking from the POV of the guest driver - i.e. that
> > virtio_net should never disable notifications on the xmit queue using
> > disable_cb()?
> >
> > Sounds like you think agree, but that the host side should throttle the
> > rate of xmit notifications?
>
> Yes.

But performance is going to suck in the meantime, as currently our host 
doesn't do this.

Rusty.
