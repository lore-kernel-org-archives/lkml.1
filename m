Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYBWHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYBWHiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 02:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYBWHin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 02:38:43 -0500
Received: from nn7.de ([85.214.94.156]:37410 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYBWHil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 02:38:41 -0500
Subject: Re: 2.6.25-rc2 regression - hang on suspend
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200802221656.28546.rjw@sisk.pl>
References: <1203422386.10992.2.camel@localhost>
	 <200802220006.39130.rjw@sisk.pl> <1203663628.8422.2.camel@localhost>
	 <200802221656.28546.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 23 Feb 2008 08:38:38 +0100
Message-Id: <1203752318.4498.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 16:56 +0100, Rafael J. Wysocki wrote:
> On Friday, 22 of February 2008, Soeren Sonnenburg wrote:
> > On Fri, 2008-02-22 at 00:06 +0100, Rafael J. Wysocki wrote: 
> > > On Thursday, 21 of February 2008, Soeren Sonnenburg wrote:
> > > > On Thu, 2008-02-21 at 01:31 +0100, Rafael J. Wysocki wrote:
> > > > > On Wednesday, 20 of February 2008, Soeren Sonnenburg wrote:
> > > > > > On Wed, 2008-02-20 at 00:50 +0100, Rafael J. Wysocki wrote:
> > [...] 
> > Also when compiling these many kernels via make -j4 I noted that I could
> > hardly move the mouse / use the keyboard, but saw random jumps and
> > key-repetitions...
> 
> This last bit is most likely a scheduler issue.  Do you have CONFIG_GROUP_SCHED
> set by chance?  If you do, please try to unset it and see if that helps.

Yes I had. Disabling this helped a lot -- the kernel seems to behave
normally with this option unset.

Soeren
