Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYK1SS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYK1SS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 13:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYK1SSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 13:18:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:43443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYK1SSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 13:18:16 -0500
Date: Fri, 28 Nov 2008 10:19:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: dynamic function tracing
Message-ID: <20081128101922.451e254a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I like the new function trace format with the {}'s a lot.. but I would
like to use it in a way I don't think would work with dynamic tracing.

What I would like to do (read: usecase) is mark a function as
interesting (because it has some performance issue or whatever),
and then I want to get all functions it calls (recursive) traced
automatically for the duration of that function.

This might be implementable by, on hitting the function to trace,
patching all trace points with a function that checks if it's this
thread (eg this "current"), and if so, traces the call. 
I realize it's not going to be super cheap, so it needs to be one-shot,
but it'll form a really strong usecase in practice...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
