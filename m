Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZKLJza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZKLJza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZKLJz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:55:29 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:59695 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZKLJz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:55:28 -0500
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 04:55:28 EST
Date: Thu, 12 Nov 2009 10:25:18 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk> (from
	julia@diku.dk on Thu Nov 12 08:49:44 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1258017918l.26867l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-12 08:49:44, Julia Lawall wrote:
> As observed by Joe Perches, sizeof of a constant string includes the
> trailing 0.  If what is wanted is to check the initial characters of
> another string, this trailing 0 should not be taken into account.  If an
> exact match is wanted, strcmp should be used instead.

Good catch.
However, in this case an exact match (with the string ".bitmap") is what
is needed, so

NAK

Will you cook up a new patch changing strncmp to strcmp?

Cheers
Anders

