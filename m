Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbXBTLBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbXBTLBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXBTLBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:01:10 -0500
Received: from ns.firmix.at ([62.141.48.66]:45270 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbXBTLBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:01:08 -0500
Subject: Re: GPL vs non-GPL device drivers
From: Bernd Petrovitsch <bernd@firmix.at>
To: v j <vj.linux@gmail.com>
Cc: davids@webmaster.com, trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	 <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix software GmbH
Date: Tue, 20 Feb 2007 12:00:51 +0100
Message-Id: <1171969251.12262.16.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.417 required=5
X-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 21:19 -0800, v j wrote:
[...]
> Now it would also be worthwhile to contemplate what EXPORT_SYMBOL_GPL
> does to this popularity. I don't know. I am just giving you my

The big problem with such discussions (as this) are: It is a law
decision which license applies in which situation. And preprocessor can
solve this (so EXPORT_SYMBOL_GPL may mean that or may only express the
wish of one/several/many/a lot of people).

Flame bait alert:
I heard a talk from an Austrian lawyer an according to his believes (and
I don't know if he is the only one or if there lots of) one must see
from the "users" view if the GPL spreads over or not (and the usual
technical terms like "linking" are basically irrelevant).
E.g.:
- You are distributing an application which links against a GPL-library.
If you provide a link and the user/customer has to get and install that
library, your application can have any license you wish.
- If you distribute an application and it installs automatically a
library (e.g. from the CD where your application is installed), your
applications license must "fit" wit the library license.

Guess now what this implies for (typical) embedded systems with one
piece of GPL code in it where you download complete firmware images -
and he explicitly confirmed that.

So this whole thing is not really defined yet and one (read: we) must
also educate such free-software-illiterate people on how it is intended
to work.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

