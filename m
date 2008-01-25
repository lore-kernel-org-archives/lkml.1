Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYAYXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYAYXux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYAYXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:50:45 -0500
Received: from smtp.digitalpath.net ([65.164.104.14]:46222 "EHLO
	smtp.digitalpath.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYAYXup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:50:45 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=digitalpath.net;
  b=oC32qMzY8EX52t3UIQ/D5dc6N/2ahS0oV7sg2YR4aeqsmnCbNh+fb7SrxVYvYWGYzI4+cgZC2Mv1Tseqfku6pcQnTxTrYydhuR5x43LMOR22BjOC1LEoQhCWqINKi+Yw  ;
Message-ID: <1788.65.164.104.9.1201305044.squirrel@webmail.digitalpath.net>
Date: Fri, 25 Jan 2008 15:50:44 -0800 (PST)
Subject: CS5536 mfgpt timer setup register hangs board
From: "Hasan Rashid" <hasan@digitalpath.net>
To: linux-kernel@vger.kernel.org
Reply-To: hasan@digitalpath.net
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have been working on a watchdog timer using the mfgpt on AMD Geode
CS5536. I initialize the setup register MFGPT0_SETUP (0x6206) with hex
value 0x306 (1100000110b). However, after this first initialization if I
ever read/write to the register it hangs the system.

I have been through all the documentation, tried several different methods
but all the efforts, frustratingly, to no avail.

Does anyone have any idea as to why would this be? TIA!

-- 
Regards,
Hasan Rashid


