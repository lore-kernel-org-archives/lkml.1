Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZEZW2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZEZW2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZEZW2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:28:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:44142 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZEZW2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:28:46 -0400
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0905261005000.3584-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0905261005000.3584-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 08:28:05 +1000
Message-Id: <1243376885.17847.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 10:06 -0400, Alan Stern wrote:
> On Tue, 26 May 2009, Benjamin Herrenschmidt wrote:
> 
> > Well, both our patches are bogus in the sense that they will leak
> > the stuff in the port structure.
> 
> That's not true at all.  Take a look at the destroy_serial() routine.

Right... hrm. This is an horrible mess, I can't wait to see that
refcount going wrong and things trying to double free or leaking the
structure.

Oh well, fix it the way your want, I don't care as long as it's fixed.
This driver is just plain horrible.

Ben.


