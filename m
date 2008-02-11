Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbYBKXHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbYBKXHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYBKXG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:06:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYBKXG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:06:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Tue, 12 Feb 2008 00:05:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
References: <1202664109.8394.19.camel@mtlp> <200802112013.53850.rjw@sisk.pl> <1202769137.7338.2.camel@mtlp>
In-Reply-To: <1202769137.7338.2.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120005.20601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of February 2008, Mirco Tischler wrote:
> > Can you send me the output of acpidump from your system, please?
> 
> I atach the output.
> 
> > BTW, does the kernel compile for you after reverting this patch?
> > 
> > Rafael
> 
> Yes, the kernel still compiles and runs on 2.6.25-rc1 with the commit
> reverted.
> I just tested it again.

Well, this is strange, because one function introduced by this commit is
referred to by the subsequent commits.  Can you send me the patch reverting
this commit that you apply on top of 2.6.25-rc1, please?

Thanks,
Rafael
