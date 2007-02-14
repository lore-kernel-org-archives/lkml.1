Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbXBNKvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbXBNKvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbXBNKvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:51:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:43238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbXBNKvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:51:37 -0500
Message-ID: <45D2E9B3.8080008@suse.de>
Date: Wed, 14 Feb 2007 11:51:31 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Subject: Re: Will smp alternative try to patch init text also?
References: <20070214104338.GA3393@in.ibm.com>
In-Reply-To: <20070214104338.GA3393@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> So what happens if somebody builds a SMP kernel and runs on a UP machine.
> Later it hotplus one CPU. Then kernel will switch to SMP mode. Looking
> at the code it looks like it will also try to patch init text which is
> no more there and will corrupt something else? 

There are range checks for both kernel (_text -> _etext) and modules
(.text section).  Anything outside isn't patched.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
