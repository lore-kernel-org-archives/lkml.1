Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYIVWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYIVWQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYIVWQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:16:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:57061 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbYIVWQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:16:04 -0400
Date: Tue, 23 Sep 2008 00:15:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dave Airlie <airlied@gmail.com>
cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, david.vrabel@csr.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>  <7lIhZC4hCxE.A.yj.E2q1IB@albercik>
  <20080921.165159.67476441.davem@davemloft.net>
 <21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008, Dave Airlie wrote:

> Sep 8th I booted my own 2.6.27-rc5 kernel based from
> ec0c15afb41fd9ad45b53468b60db50170e22346
> This got a corrupted e1000e checksum and every kernel since has.

Have you restored the EEPROM contents after it got corrupted for the first 
time?

Once the EEPROM contents get corrupted, the card will then be broken
forever even on kernel that gets this fixed one day. 

This is pretty serious bug in fact, as it renders hardware of poor users 
unusable, and just patching kernel is then not enough to put things back 
to shape.

-- 
Jiri Kosina
SUSE Labs

