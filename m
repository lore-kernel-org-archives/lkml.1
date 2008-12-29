Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYL2Mfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYL2Mfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYL2Mfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:35:44 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:52814 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYL2Mfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xTvBuBVB6FaOzjWtn+1WlvSq4sLzXhmFWO1HRULfAflf4Jl6jJ92HNPpNwyi+HObl4
         /ta8Jm34gw+moe55fhaL7gEDpn3RigezmA1e3Ot3QUmVabjE0s1GQxHXB6W0JPYKriDG
         /+n9Z2qsx0q3vnKCTvzT+V8HQFow1NgGuwaH0=
Message-ID: <8bd0f97a0812290435l12b0eb0ds11c1c56428cfc4a1@mail.gmail.com>
Date: Mon, 29 Dec 2008 07:35:42 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: walt <w41ter@gmail.com>
Subject: Re: Should <linux/serial.h> define __u32?
Cc: linux-kernel@vger.kernel.org, "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <4957FCA4.4010201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
	 <20081010103637.31597.41557.stgit@localhost.localdomain>
	 <4957FCA4.4010201@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 17:24, walt <w41ter@gmail.com> wrote:
> So, my question is:  who should be responsible for defining
> that __u32, the author of serial.h or the author of the wine
> code that includes serial.h?

the kernel header should be doing #include <linux/serial.h>

if your distro doesnt patch their current headers to do this, then you
should open a bug report for them
-mike
