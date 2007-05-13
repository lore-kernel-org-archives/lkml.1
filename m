Return-Path: <linux-kernel-owner+w=401wt.eu-S934566AbXEMQaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934566AbXEMQaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbXEMQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:30:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:45850 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbXEMQaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:30:06 -0400
To: Robert Hancock <hancockr@shaw.ca>
Cc: Bill Davidsen <davidsen@tmr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful" document
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no>
	<fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 13 May 2007 18:30:04 +0200
In-Reply-To: <4646082D.2080502@shaw.ca> (Robert Hancock's message of "Sat, 12 May 2007 12:32:13 -0600")
Message-ID: <m33b208z5f.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> writes:

> You don't need volatile in that case, rmb() can be used.

rmb() invalidates all compiler assumptions, it can be much slower.
-- 
Krzysztof Halasa
