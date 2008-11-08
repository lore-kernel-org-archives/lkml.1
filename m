Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYKHTqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYKHTqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYKHTqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:46:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43186 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYKHTqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:46:25 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4915EC7B.9080607@s5r6.in-berlin.de>
Date: Sat, 08 Nov 2008 20:46:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: detect and log TSB81BA3 erratum
References: <tkrat.f09c80ed76dd6c79@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f09c80ed76dd6c79@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
[...]
> TI's "TSB81BA3 Errata (Rev. C)" SLLZ015C.  These resets cause massive
> I/O failures.
> 
> Self-ID complete events after such resets consistently show more than
> one self-ID zero packet with i bit set ( = initiated reset).  If this
> happens, emit a warning in dmesg and suggest hardware workarounds to the
> user.

Apparently two initiators are OK when a node joins a bus.  My alarm goes
off too quickly.
-- 
Stefan Richter
-=====-==--- =-== -=---
http://arcgraph.de/sr/
