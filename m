Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYH2Lhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYH2Lhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYH2Lhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:37:47 -0400
Received: from alto.filmlight.ltd.uk ([217.40.27.25]:17112 "HELO
	a.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752335AbYH2Lhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:37:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 07:37:46 EDT
Message-ID: <48B7DDF7.7060107@filmlight.ltd.uk>
Date: Fri, 29 Aug 2008 12:31:03 +0100
From: Roger Willcocks <roger@filmlight.ltd.uk>
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<1219945263-21074-6-git-send-email-tj@kernel.org>	<20080828175116.GB18461@kroah.com>	<48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org>	<E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>	<48B6EBBD.6050406@kernel.org>	<E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>	<48B6EF98.4070008@kernel.org>	<E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>	<48B6FFB6.7000104@kernel.org>	<E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu> <48B75C94.7030604@kernel.org>
In-Reply-To: <48B75C94.7030604@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One thing to bear in mind is the possibility of 32-bit client programs 
running on a 64-bit platform, so your user-space driver will need be be 
aware of the flavour of the client, and parse the ioctl arguments (and 
in particular, pointers) appropriately.

That's true of a kernel implementation too, of course.

--
Roger



