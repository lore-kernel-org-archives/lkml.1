Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYJKUuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYJKUuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYJKUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:49:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbYJKUtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:49:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
Date: Sat, 11 Oct 2008 22:54:08 +0200
User-Agent: KMail/1.9.9
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux acpi <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810112140.16662.rjw@sisk.pl> <48F100CA.2050600@suse.de>
In-Reply-To: <48F100CA.2050600@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810112254.09094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 11 of October 2008, Alexey Starikovskiy wrote:
> Rafael J. Wysocki wrote:
> >> No, we discussed this before -- we are outside of the transaction, thus 
> >> no GPE
> >> activity could interfere with ec_check_ibf0.
> > 
> > Ok, this is in the process context and we don't really expect to get an
> > interrupt at this point, but what happens if the EC generates an event that's
> > not related to any transiaction.  Is that guaranteed to never happen?
> Interrupt handler in this case can't cause a change to status register, thus our 
> read of it will not be affected by interrupt.

Ok, thanks.

Alan, does the patch work for you?

Rafael
