Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbZDBXhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbZDBXhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbZDBXhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:37:01 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:59030 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbZDBXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WQyMX3N4YaukglV4IVUW8oF9NwHcfyHxDsFBuo9BV5f5yNhh0JcPRDQNjUBYuMYcFP
         5ByYVkGyWp7JoQ/vaKC6yARyYIYGl1iGBTxGlC7uDSc0BRkc0S+bo5RzAsBFbK62+b6l
         5A+y66PkpRhX5wexb3a7b9I1/GfQpegUx5wJw=
Subject: Re: [Lguest] [PATCH 4/5] lguest: use KVM hypercalls
From: Matias Zabaljauregui <zabaljauregui@gmail.com>
To: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org,
       lguest@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org,
       Matias Zabaljauregui <zabaljaureguiatgmail.com@ozlabs.org>
In-Reply-To: <1238709324.5823.8.camel@odie.local>
References: <200903271022.38244.rusty@rustcorp.com.au>
	 <1238709324.5823.8.camel@odie.local>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Apr 2009 20:37:28 -0300
Message-Id: <1238715448.29787.6.camel@zetabook>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 23:55 +0200, Simon Holm Thøgersen wrote:
> fre, 27 03 2009 kl. 10:22 +1030, skrev Rusty Russell:
> > From: Matias Zabaljauregui <zabaljauregui@gmail.com>
> > 
> > Impact: cleanup
> > 
> > This patch allow us to use KVM hypercalls
> 
> Something has broken in relation to this change. I'm not sure it is this
> change itself or one following, but I get the following error when using
> lguest:
> 
> lguest: unhandled trap 6 at 0x418726 (0x0)


Hi, could you please attach your config? 
are you using the same kernel for guest and host?

I just tested it with 2.6.29-07100-g833bb30  and works OK for me.

thanks
Matias

