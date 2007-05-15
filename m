Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXEOJNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXEOJNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbXEOJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:13:37 -0400
Received: from zakalwe.fi ([80.83.5.154]:39804 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbXEOJNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:13:37 -0400
Date: Tue, 15 May 2007 12:12:46 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: On __pure and __attribute_pure__
Message-ID: <20070515091246.GE10873@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Both __pure and __attribute_pure__ are the same, and I found out that 
there is only a handful of users for these. __attribute_pure__ is 
used in approximately 15 places, and __pure is not used anywhere.

Is either __pure or __attribute_pure__ preferred? Imo, __pure looks 
much nicer than __attribute_pure__ so we could do a replacement.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
