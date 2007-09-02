Return-Path: <linux-kernel-owner+w=401wt.eu-S1751077AbXIBSxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbXIBSxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbXIBSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:53:43 -0400
Received: from relay.hkfree.org ([89.248.240.5]:53931 "EHLO
	mail.hades.hkfree.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbXIBSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:53:43 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2007 14:53:42 EDT
Message-ID: <46DB0239.2070304@assembler.cz>
Date: Sun, 02 Sep 2007 20:34:33 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon coretemp: Remove bogus __cpuinitdata etc cleanup
References: <alpine.LFD.0.999.0708230910120.2049@enigma.security.iitk.ac.in> <20070902154152.GC19101@jupiter.solarsys.private>
In-Reply-To: <20070902154152.GC19101@jupiter.solarsys.private>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> [ Rudolf, Mark, would it be acceptable to you to remove all the open
>>   #ifdef HOTPLUG_CPU from this file and replace them with __cpuinit{data}
>>   instead? That could increase size of modular builds, but would remain
>>   consistent with rest of kernel, and make the file #ifdef-clean ... ]

Well I dont have any strong preference. I agree with Mark that that #ifdef is
easy to read.

Rudolf
