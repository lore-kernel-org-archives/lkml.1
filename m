Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYBAR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYBAR6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYBAR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:57:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:54161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbYBAR5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:57:55 -0500
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] [12/12] GBPAGES: Switch direct mapping setup over to set_pte
Date: Fri, 1 Feb 2008 18:58:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <200802011053.107168490@suse.de> <20080201095325.6419E1B416F@basil.firstfloor.org> <47A358DB.4010602@goop.org>
In-Reply-To: <47A358DB.4010602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011858.41269.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why?  64-bit Xen will need this to be set_pmd if its an update to L2 of
> the table.

Then change_page_attr() and hugepages will already not work because they both 
do exactly that.

And I didn't want to duplicate this manual code for the GBpages case, so i 
changed it everywhere to the standard way.

-Andi


>     J


