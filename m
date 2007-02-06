Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbXBFSD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbXBFSD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXBFSD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:03:29 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:1981 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933150AbXBFSD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:03:29 -0500
X-Greylist: delayed 1856 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 13:03:28 EST
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: linux-kernel@vger.kernel.org
Subject: cpu load balancing problem on smp
Date: Tue, 6 Feb 2007 18:32:17 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061832.17771.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi @all

we have detected some problems on our live systems and so i have build a test 
setup in our lab as follow:

3 Core 2 duo servers, each with 2 CPUs,  with GE interfaces. 2 of them are 
only for generating network traffic. the 3rd server is the one i want to 
test. it is connected over two GE links to the other servers. the testserver 
is configured as an ip router. running kernel 2.6.20. 

now if i  let traffic flow over the box, about 600Mbit/s and about 120k 
packets/s all seems to be ok. the load is balanced over all cpus. if now 
insert some iptables rules, about 500, the softirq load increases, but all 
seems to be ok. now i insert some rules more, and suddenly 1 CPU is 100% 
loaded and the other ones are 99% idle. the load toggles now between the cpus 
in intervals.

i have made some graphs http://www.poweraudio.de/linux/cpu.html  

this seems to me to be not normal.

any suggestions?

regards
Marc
