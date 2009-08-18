Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbZHRPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbZHRPl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759284AbZHRPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:41:57 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:36538 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbZHRPl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:41:56 -0400
Message-ID: <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20090818151427.GA6295@kroah.com>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
    <20090818151427.GA6295@kroah.com>
Date: Tue, 18 Aug 2009 09:41:56 -0600
Subject: Re: Purpose of parameter in sysfs binary read
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Greg KH" <greg@kroah.com>
Cc: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr. wrote:
> What are you using the binary sysfs attribute for?  It should ONLY be
> used as a pass-through to and from hardware, with no interpretation by
> the kernel at all.

It's for the Logitech G13's game panel image (a simple binary bitmap of
the pixels).

It doesn't do any interpretation... just a few checks on the magic number
and size.

