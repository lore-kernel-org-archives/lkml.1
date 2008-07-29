Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYG2DXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYG2DXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYG2DXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:23:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:1780 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYG2DXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jqTpuc0rwEDe+zRDmN88RBYmDFheD/oHIQcH4t7fyr5IeWmExJa/3FNPw1PSAm8+r9
         t4/gheuC0vNkqcL4FpUYtMTHwwVRcnbbL0gCyIJ0ov6rrQKbEMU7F/0r0Af6vGPUQunf
         8qmDPSBHjfBgm7uqI0EOqleoZEbMX9K6a0u1A=
Message-ID: <9e4733910807282023h5479c755wde55e2324909b678@mail.gmail.com>
Date: Mon, 28 Jul 2008 23:23:31 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Al Viro" <viro@zeniv.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080729025016.GT9378@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488DFD97.7080802@simon.arlott.org.uk>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080729011526.GF28946@ZenIV.linux.org.uk>
	 <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com>
	 <20080729013650.GG28946@ZenIV.linux.org.uk>
	 <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com>
	 <20080729025016.GT9378@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Jul 28, 2008 at 10:01:06PM -0400, Jon Smirl wrote:
>  > I should also point out that external information (Google) was needed
>  > to identify several hundred names, there was insufficient information
>  > in the log or kernel source. If we have to reconstruct this mapping
>  > ten years from now for some random lawsuit, the external information
>  > may not be there.
>
>
> Jon,
>
>         The reality is ten years from now, many e-mail addresses won't
>  be accurate anyway.  We will have to track people down by hand, if it
>  ever comes down to that.  The signed-off-by needs to be enough so we
>  can track down someone (very likely only a few set of people); via a
>  manual method is quite acceptable.  I don't think it is really
>  necessary to try force fit the signed-off-by just so we can collect
>  better mode.

The kernel already has a mailmap file, but it is not complete. So I
should just take this work that makes the mailmap file a lot better
and throw it away? The policy is that the log file should be messed up
enough so that a computer can't process it and that a human can
recover it only with several day's effort? That's a really hard line
to define and we'll probably lose the identity of a bunch of
contributors. I'll follow up with a patch that deletes the current
.mailmap

-- 
Jon Smirl
jonsmirl@gmail.com
