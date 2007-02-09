Return-Path: <linux-kernel-owner+w=401wt.eu-S1946608AbXBIQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946608AbXBIQ1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946611AbXBIQ1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:27:19 -0500
Received: from octopussy.ethz.ch ([129.132.86.190]:41257 "EHLO
	octopussy.ethz.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946608AbXBIQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:27:18 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 11:27:18 EST
Message-ID: <45CC9C78.5050501@isotton.com>
Date: Fri, 09 Feb 2007 17:08:24 +0100
From: Aaron Isotton <aaron@isotton.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Getting tcp_sock in tcp_parse_options
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I am porting a kernel patch and module from 2.4 to 2.6. Part of the
patch implements a new TCP options, so it extends tcp_parse_options.
Since the patch has to maintain a state it adds some new fields to
struct tcp_sock which should then be updated from tcp_parse_options.

I had to notice that using tcp_sk(skb) inside tcp_parse_options always
(or at least in all cases I tested) returns NULL. So, how do I get the
tcp_sock structure associated with the connection in tcp_parse_options?

As a side note: is there any documentation about the Linux TCP/IP stack
(except what's in Documentation/ and the comments)?

Thank you very much,
Aaron
