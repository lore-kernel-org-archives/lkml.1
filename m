Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZCVXNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZCVXNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbZCVXM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:12:59 -0400
Received: from mail.crca.org.au ([67.207.131.56]:53266 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbZCVXM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:12:59 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Mar 2009 19:12:58 EDT
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [RFC][PATCH 1/2] PCI PM: Introduce
 __pci_set_power_state()
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200903222211.50930.rjw@sisk.pl>
References: <200903210003.55161.rjw@sisk.pl>
	 <200903222208.22434.rjw@sisk.pl>  <200903222211.50930.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 10:08:05 +1100
Message-Id: <1237763285.11186.2.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

It's not an error if we fail to set the desired state? (I see you have a
dev_warn only).

(If it is an error, the radeon_set_suspend patch needs to be adjusted to
not ignore the error code).

Regards,

Nigel

