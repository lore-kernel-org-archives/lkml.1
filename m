Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZIUHgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZIUHgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZIUHgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:36:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:48686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZIUHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:36:41 -0400
Date: Mon, 21 Sep 2009 09:36:52 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu
Subject: TRACE_EVENT_ABI ?
Message-ID: <20090921093652.0722d745@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo suggested to make a TRACE_EVENT_ABI, which is equivalent in
implementation to TRACE_EVENT, except that it signals a stable
interface.

In trying to implement this I'm running into a wall where TRACE_EVENT
keeps being defined in many different ways all over the place, making
this a really nasty hack to make it just an alias.

Do you have any clever ideas on how to make this an alias without
fouling up the whole tracing system?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
