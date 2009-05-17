Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZEQVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZEQVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZEQVI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 17:08:59 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:37570 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZEQVI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 17:08:58 -0400
Subject: [tracing] ring_buffer question
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 17 May 2009 17:08:25 -0400
Message-Id: <1242594505.6327.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

Is there any reason you can think of why we don't just generalize
kernel/trace/ring_buffer into kernel/ring_buffer, remove the static
per_cpu buffer allocation and have this available for non-tracing?

As it is, trace buffers only store generic data and the design (swap on
read) is very nicely done for many other ring buffer uses.

Jon.


