Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZB1N6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZB1N6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZB1N62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:58:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42639 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZB1N61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:58:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A942F6.3020600@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 14:58:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk>
In-Reply-To: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Try to help ensure that e-mailed patches have some commit log text in
> the body of the e-mail by warning if we can't find any lines that look
> like a header of some kind prior to the Signed-off-by.

This gives false positives for patches like this:

From: [...]
Subject: this single line fully explains the whole patch

Signed-off-by: [...]
---
[...]

-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
