Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759Ab0A3EcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab0A3EcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 23:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484Ab0A3EcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 23:32:21 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:58545 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0A3EcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 23:32:20 -0500
Subject: why is nf_conntrack_htable_size exported?
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 29 Jan 2010 23:32:11 -0500
Message-Id: <1264825931.7156.2.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Can someone tell me why nf_conntrack_htable_size is both an exported
symbol, and available in sysfs to be changed? Doing so will surely cause
the system to fall over immediately since this is value is used within
the hashing code in conntrack. It is /supposed/ to only be changed under
a lock, or at init time when there is not a need to lock it.

Perhaps we can get this unexported asap and the value replaced with a
function that returns the current value instead? Same goes for the
module parameter that can freely be messed around with.

Thanks,

Jon.


