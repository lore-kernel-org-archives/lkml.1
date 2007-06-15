Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbXFOVvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbXFOVvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXFOVux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:50:53 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:57403 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbXFOVuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:50:52 -0400
Message-ID: <467309B8.2060001@dgreaves.com>
Date: Fri, 15 Jun 2007 22:50:48 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-pm <linux-pm@lists.osdl.org>
Subject: 2.6.22-rc4 hibernate disables skge wol
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've started a new thread here since the old one got somewhat hijacked.

Rafael J. Wysocki wrote:
 > On Friday, 1 June 2007 23:23, David Greaves wrote:
 >> Not a regression though, it does it in 2.6.21
 >>
 >> If I cause the system to save state to disk then whilst off it no longer
 >> responds to g-wol.
 >
 > Can you please try with the hibernation and suspend patch series from
 >
 > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/
 >
 > applied?
 >
 > Greetings,
 > Rafael
 >
 >
Now, IIRC, some time ago you asked me to try some patches :)

So I applied them (and Tejun's fixes as per the old thread) to rc4 (which seems 
to include a couple already).

Hibernate/resume works but although WOL works on an init 0, it doesn't work on a 
hibernated system :(

David

