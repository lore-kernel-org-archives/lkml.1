Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZHLKyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZHLKyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbZHLKyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:54:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbZHLKyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:54:22 -0400
Date: Wed, 12 Aug 2009 13:52:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com
Subject: Re: [PATCHv2 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090812105241.GA28848@redhat.com>
References: <cover.1249992497.git.mst@redhat.com> <20090811212802.GC26309@redhat.com> <4A82076A.1060805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A82076A.1060805@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 08:06:02PM -0400, Gregory Haskins wrote:
> > diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> > index 0521177..781a8bb 100644
> > --- a/include/linux/miscdevice.h
> > +++ b/include/linux/miscdevice.h
> > @@ -30,6 +30,7 @@
> >  #define HPET_MINOR		228
> >  #define FUSE_MINOR		229
> >  #define KVM_MINOR		232
> > +#define VHOST_NET_MINOR		233
> 
> Would recommend using DYNAMIC-MINOR.

Good idea. Thanks!

-- 
MST
