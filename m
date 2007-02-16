Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbXBPN6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbXBPN6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbXBPN6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:58:54 -0500
Received: from zakalwe.fi ([80.83.5.154]:37784 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349AbXBPN6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:58:53 -0500
Date: Fri, 16 Feb 2007 15:58:51 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] New driver information
Message-ID: <20070216135851.GA7939@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just read

	http://kerneltrap.org/node/7729

and it occured to me that it would be informative to have a new device 
driver macro. The motivation for the new macro would be 4 issues:

	* Is it possible to get specifications for the device?
	* If yes, under what terms? (nda, public)
	* Where to get public specs?
	* How many closed and open drivers in the Linux source tree?

I suggest to add following macro:

MODULE_SPECIFICATION(terms, source);

where "terms" is one of

 * MODULE_SPEC_ANY_PARTY_NDA
	- specification available to any party for an NDA
 * MODULE_SPEC_ANY_PARTY
	- specification available in public, or at least available 
	  without NDA to any party
 * MODULE_SPEC_RESTRICTED
	- none of the above

and "source":

 * contact address for nda specs
 * any public source for a public specification (http://, email address, 
   ...)
 * empty string otherwise

I realise this macro somewhat circumvents the purpose of Documentation/ 
directory but the idea is to have a direct 1:1 mapping between drivers 
and specification sources so that it would be easy to collect statistics 
of "open" hardware by using grep et al.

What do you think? Useless annotations or useful information?

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
