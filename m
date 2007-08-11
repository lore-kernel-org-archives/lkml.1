Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbXHKU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbXHKU1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 16:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbXHKU1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 16:27:04 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:20501 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760847AbXHKU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 16:27:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cw7YmddnVIWHpo3aHCt6Ls9lXAJpzc7YcWzQRVmYpShrO8hOLzUDuv6qo7bQGgF2XOQ/0emPJ+D1ASv2IO5UB9hP6lFuDtzP4CNJRVKQQ2ddQq3HOFZsssAnTuDGGmcy7H2e/LpxjZiAbWNCZMFtYwIpkENMok/A628vHo7Fj/0=  ;
X-YMail-OSG: pcFvBccVM1mmAyTicSGdiwJjetG_BF5j8Ssf0qKDVGzzgkq0dB60PzclXnUD7hvEvZNwSNDYrw--
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level> messages
Date: Sat, 11 Aug 2007 12:31:34 -0700
User-Agent: KMail/1.9.6
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
       Roland Dreier <rolandd@cisco.com>, James Smart <james.smart@emulex.com>,
       Hansjoerg Lipp <hjlipp@web.de>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
References: <1186535381.11897.29.camel@localhost> <20070811092342.53106dfb@hyperion.delvare>
In-Reply-To: <20070811092342.53106dfb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708111231.35442.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007, Jean Delvare wrote:
> Note that there are 3 more messages to fix in
> drivers/i2c/chips/menelaus.c (3 calls to pr_err.)

I'd hope those will get fixed by final versions of the
patches I've seen floating around definining a standard
pr_err() ... not fixing them here allows the two patches
to not conflict.  :)

- Dave

