Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZG0Tjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZG0Tjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZG0Tjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:39:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZG0Tjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:39:48 -0400
Message-Id: <200907271939.n6RJdjtk031717@dell2.home>
To: linux-kernel@vger.kernel.org
cc: martyleisner@yahoo.com
Subject: ipReasmTimeout in /proc/net/snmp is wrong
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31714.1248723585.1@dell2.home>
Date: Mon, 27 Jul 2009 19:39:45 +0000
From: "Marty Leisner" <leisner@rochester.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RFC1213/2011, it says:

ipReasmTimeout OBJECT-TYPE
    SYNTAX      Integer32
    MAX-ACCESS  read-only
    STATUS      current
    DESCRIPTION
            "The maximum number of seconds which received fragments are
            held while they are awaiting reassembly at this entity."
    ::= { ip 13 }

This is correctly reflected in
/proc/sys/net/ipv4/ipfrag_time

>From /proc/net/snmp:
IP:ReasmTimeout is a counter -- incremented in net/ipv4/ip_fragment/ip_expire.

I think this is incorrect.
(this is in all kernels from 2.6.20-30).

Note sure what will be the most expedient way to rectify this.


marty
