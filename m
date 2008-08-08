Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYHHC7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYHHC7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYHHC7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:59:46 -0400
Received: from zen.handcraftedcomputers.com.au ([203.122.247.90]:4701 "EHLO
	zen.handcraftedcomputers.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbYHHC7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:59:46 -0400
Message-ID: <489BB68E.7040508@handcraftedcomputers.com.au>
Date: Fri, 08 Aug 2008 12:29:26 +0930
From: Daryl Tester <dt-lkml@handcraftedcomputers.com.au>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Sven Wegener <sven.wegener@stealer.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM?: "permission denied" when accessing /proc/self/fd/*
 after setuid
References: <489A9357.50105@handcraftedcomputers.com.au> <alpine.LNX.1.10.0808071311300.16201@titan.stealer.net> <489B957D.9080206@handcraftedcomputers.com.au> <20080808005049.GA20707@martell.zuzino.mipt.ru> <489BAE70.5080909@handcraftedcomputers.com.au>
In-Reply-To: <489BAE70.5080909@handcraftedcomputers.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daryl Tester wrote:

> Alexey Dobriyan wrote:

>> Something similar was fixed in 2.6.22, but let me check.

Oh, hang on, that's just for directory access.  That still
leaves the issue of the open() vs dup() semantics.  Nuts.

Cheers,
  --dt
