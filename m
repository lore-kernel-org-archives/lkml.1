Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXIEAMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXIEAMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 20:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbXIEAMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 20:12:41 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:44762 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbXIEAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 20:12:40 -0400
Subject: 2.6.22.6 + rt9: suspend/hibernate not working
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: nando@ccrma.Stanford.EDU, planetccrma@ccrma.Stanford.EDU
Content-Type: text/plain
Date: Tue, 04 Sep 2007 17:12:34 -0700
Message-Id: <1188951154.26511.90.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo... I'm getting reports from some of my Planet CCRMA users (which
I confirmed) that the latest rt kernel I released has broken suspend
(tested on fc6 & fc7, stock Fedora kernel works fine - the rt
configuration files are virtual clones as far as possible of the
standard Fedora kernel config files). 

I don't know where to start debugging this. When suspend is initiated it
freezes with a "Stopping tasks ... " message in the text console - a
hard power cycle is the only way to get the machine back to normal. 

kernel/power/process.c seems to contain that string in the
freeze_processes function so it looks like the freezer is not freezing
tasks as no "done" message is ever printed. 

What could we do to help?
-- Fernando


