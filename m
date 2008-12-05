Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYLEU2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYLEU2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 15:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLEU1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 15:27:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYLEU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 15:27:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Dave Airlie" <airlied@gmail.com>
X-Fcc: ~/Mail/linus
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       libc-alpha@sources.redhat.com
Subject: Re: IO space memcpy support for userspace.
In-Reply-To: Dave Airlie's message of  Friday, 5 December 2008 13:40:43 +1000 <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
X-Zippy-Says: I know how to get the hostesses released!  Give them their own
    television series!
Message-Id: <20081205202746.7DB20FC379@magilla.sf.frob.com>
Date: Fri,  5 Dec 2008 12:27:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is never going to be something in memcpy that makes any magical
kernel calls to find out about an address.  That's just loony, sorry.
memcpy is inlined away by the compiler in good cases.  It's like you'd
asked for "*ptr" to have magical constraints by the compiler generating
code to ask the kernel if "ptr" is a special address.  Uh, really?

If you can think of an efficient way to determine it and do what you need,
then you could write optimized routines that do that in the vDSO perhaps.


Thanks,
Roland
