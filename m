Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXHWDyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXHWDyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXHWDyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:54:45 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:63477 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbXHWDyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:54:44 -0400
Date: Wed, 22 Aug 2007 23:54:41 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Ideas on column length in kernel "problem"?
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen any recent solutions to this "problem"...

Many free (and not-free) mail clients wordwrap.  Hushmail wraps at 
68 (verified), Yahoo has options to wrap at a max of 99, and Gmail 
was somewhere around 85-90 as I recall.  Not sure on other free / 
inexpensive clients.  

However, several code modules have code lines with column lengths 
well over 80 (the worst I have seen was 211).  This prevents people 
with "minimal function" email clients (I'm being generous) from 
making changes in the area of these long code lines, or from even 
submitting fixes for the line length problem in modules themselves.

I don't have an easy solution short of finding volunteer(s) who can 
submit patches to resolve this or peer-pressuring module owners 
into resolving, so opening this issue up to the list for ideas 
here.  In the meantime I'll run a quick review to assess just how 
many changes this would be ...

Note -- I am well aware that us 'poor users' could just 'get a real 
email service', and if anyone knows of a free/inexpensive mail 
client that will be able to handle the wordwrap requirements for 
the current state of the linux tree please advise.

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

