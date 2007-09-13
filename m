Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXIMNR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXIMNR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbXIMNRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:17:48 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:42162 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbXIMNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:17:47 -0400
Date: Thu, 13 Sep 2007 14:40:34 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
       video4linux-list@redhat.com, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
Message-ID: <20070913124034.GA26972@linuxtv.org>
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota> <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com> <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com> <rjsmr4-rc8.ln1@tux.abusar.org> <d9def9db0709122258l4b05546dq2e370e67a2a1404@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0709122258l4b05546dq2e370e67a2a1404@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 84.190.150.24
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007, Markus Rechberger wrote:
> 
> We currently have an implementation that works, although
> it works by downloading several firmwares for several devices 
> or even several countries. This is not what I want to have in 
> future since it's not needed and it's also hard to manage for
> distributors. All those differences could be adjusted by 
> software even without module parameter hacks.

This argument doesn't hold water. The unpleasant point
for users and distributors isn't the "binary-only"
thing, it's the "no right to distribute" problem.
And that's the same for firmware blobs or binary-only
userspace blobs.

IOW, if you can get the right to redistribute a binary-only
userspace blob which incudes the firmware inside, why
shouldn't you be able to get the right to redistribute
just the firmware?

Or the other way round: Do you think your binary-only software
will be important enough so distributors will go through
all the trouble of trying to get a license to include it in
their distribution? If so, why wouldn't they do the same
for the plain firmware blobs for in-kernel drivers?


Johannes
