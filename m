Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYCWLQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYCWLQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbYCWLQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:16:10 -0400
Received: from venema.h4ckr.net ([217.24.1.135]:48396 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbYCWLQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:16:08 -0400
X-Greylist: delayed 1595 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2008 07:16:08 EDT
Message-ID: <51945.213.10.206.148.1206269365.squirrel@webmail.madwifi.org>
In-Reply-To: <43e72e890803061755x17b2a626xddd7dd71a92a80c5@mail.gmail.com>
References: <43e72e890802261555i37d8f470q9ac16df8140740fe@mail.gmail.com>
    <200803051132.24020.bruno@thinktube.com>
    <43e72e890803061755x17b2a626xddd7dd71a92a80c5@mail.gmail.com>
Date: Sun, 23 Mar 2008 11:49:25 +0100 (CET)
Subject: Re: [RFC] Linux central regulatory domain agent - next stage
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "bruno randolf" <bruno@thinktube.com>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, "Jouni Malinen" <j@w1.fi>,
       "Larry Finger" <larry.finger@lwfinger.net>,
       "Sam Leffler" <sam@errno.com>, "Dan Williams" <dcbw@redhat.com>,
       "Ivan Seskar" <seskar@winlab.rutgers.edu>,
       "Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Tim Gardner" <tim.gardner@canonical.com>,
       "Jean Tourrilhes" <jt@hpl.hp.com>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

> Well the whole notion of using a db was for the purpose of
> presentation and for easy review. I'd like to make it easy for
> non-developers to contribute changes to the regulatory db.

How about keeping the master file in a yet-to-be-defined XML format?

It's not too hard to make the webserver display it (via XSLT, some
server-side script or whatever). Even without the webserver being
available it's possible for a human to make sense of the content of the
master file.

Being a text file it can be managed with virtually any version control
system. It's possible to make sense of and understand all recorded changes
without additional tools.

Users of the file could decide to compile the master file from XML into
whatever format their tools prefer. For Linux it would be some binary
format, for the reasons stated earlier in this thread. Other OS/users
might decide on something else, even on using the master file as is.

The compiler could use a standard XML library, making it easy for
distributors to satisfy the dependencies. If necessary it could fall back
on it's own simple XML parser. Support for various output formats could be
implemented as modules or even as plugins.

Just my 2 cents.

Bye, Mike
