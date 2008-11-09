Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYKIS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYKIS1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 13:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYKIS1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 13:27:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:14192 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbYKIS1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 13:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uGFDs1QCsioWBc9FKYH+Is7O7+ivCmsnqytPJ34lVdWtIFvD3C0vUM7yZ5I2J3vsSA
         kpFx02tuERowsIMITjVBAMkIG40Sisfr/8F3xflci4gwEzALUFgm52NiPgDIzw0oJivt
         A+4TzQjzNZymCvhwzkNnQ9UDpIsR2weK+nw2M=
Date: Sun, 9 Nov 2008 21:30:43 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081109183043.GA4530@x200.localdomain>
References: <4917263D.2090904@telenet.dn.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917263D.2090904@telenet.dn.ua>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 08:04:45PM +0200, Vitaly V. Bursov wrote:
> I'm building small server system with openvz kernel and have ran into
> some IO performance problems. Reading a single file via NFS delivers
> around 9 MB/s over gigabit network, but while reading, say, 2 different
> or same file 2 times at the same time I get >60MB/s.

openvz kernels have very changed CFQ and, IIRC, this one-reader problem is
fixed somewhere. Ask devel@openvz.org.
