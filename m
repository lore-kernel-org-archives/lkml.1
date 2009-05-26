Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZEZOGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZEZOGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZEZOG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:06:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45619 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147AbZEZOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:06:27 -0400
Date: Tue, 26 May 2009 10:06:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
In-Reply-To: <1243288836.2858.5.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0905261005000.3584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Benjamin Herrenschmidt wrote:

> Well, both our patches are bogus in the sense that they will leak
> the stuff in the port structure.

That's not true at all.  Take a look at the destroy_serial() routine.

Alan Stern

