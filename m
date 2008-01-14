Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYANII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYANII1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYANIIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:08:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:5500 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYANIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:08:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vdvvl/imM3NrUT8mmOIShApipdPuItRIBsrVBj0peYIOQlyLp6+ZpQdOUWHIUHtO1McZkQsztTi1QR16hl2p2U0XCotzbUBm2RqNxvkKvvIPsrSx24VW8YONhe+Y7YG6fxv2svfoZBKVU20fsCniz3dy6T0EVxGHL6WE1k0C2uM=
Message-ID: <8bd0f97a0801140008x274d4e27lbaefc7c10ea02629@mail.gmail.com>
Date: Mon, 14 Jan 2008 03:08:16 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Florian Fainelli" <florian.fainelli@telecomint.eu>
Subject: Re: [RFC, PATCH] watchdog on gpio
Cc: "Marc Pignat" <marc.pignat@hevs.ch>, wim@iguana.be,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801111740.25754.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101611.08867.marc.pignat@hevs.ch>
	 <200801111740.25754.florian.fainelli@telecomint.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 11:40 AM, Florian Fainelli
<florian.fainelli@telecomint.eu> wrote:
> Did you look into hooking into Wim's uniform watchdog driver :
>
> http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-experimental.git;a=commit;h=732c54027e6c866f98857c4a6d1c6c466459dcd5
>
> Maybe you can save some code ?

seems like it'd be pointless for Marc to look at using this if it isnt
slated for merging into mainline anytime soon.

that said, i'd love to see a watchdog "core" as it pains me to see how
80% of all watchdogs are pretty much copy & paste & variable/function
renaming.
-mike
