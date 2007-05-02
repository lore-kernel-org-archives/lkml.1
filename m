Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbXEDB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbXEDB7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 21:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXEDB7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 21:59:22 -0400
Received: from outbound3.mail.tds.net ([216.170.230.93]:42270 "EHLO
	outbound3.mail.tds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbXEDB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 21:59:21 -0400
X-Greylist: delayed 96385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 21:59:21 EDT
Subject: Re: Detecting process death for anycast named process monitoring
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Glen Turner <gdt@gdt.id.au>, Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4639111A.70202@nortel.com>
References: <4638FCEA.4010806@gdt.id.au>  <4639111A.70202@nortel.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 18:12:27 -0500
Message-Id: <1178147547.26507.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 16:30 -0600, Chris Friesen wrote:
> Glen Turner wrote:
> 
> > The question is, how can a process with no relationship to another
> > process detect that process unexpectedly dying?  If named goes
> > away to a better place, we want to shut down the interface
> > which causes Quagga to inject the anycast route.

> We did something similar where arbitrary processes can register to be 
> sent an arbitrary signal when the state of other processes change.

What about something like inotify, but for processes?  That would be
cool...

- DML

