Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFPR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFPR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYFPR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:58:34 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:56303 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYFPR6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:58:34 -0400
Date: Mon, 16 Jun 2008 17:58:33 +0000
From: Sean Young <sean@mess.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080616175833.GA54900@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <48569D96.1090904@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48569D96.1090904@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 10:06:30AM -0700, H. Peter Anvin wrote:
> Sean Young wrote:
> >
> >>What bootloader does this platform use?  I wonder if it's setting things 
> >>up in an unexpected way?
> >
> >It's syslinux. That must be the culprit, considering the change to 
> >head_32.S.
> >
> >I'm digging in syslinux right now. 
> >
> 
> What makes you draw that conclusion?

The thinking was that syslinux sets the boot parameters which are being read 
in head_32.S. I've used syslinux 3.53 but have just moved to 3.63.

That was the theory at least. I'm not sure what's going on now. I'll spend
some more time on this.

Thanks
Sean
