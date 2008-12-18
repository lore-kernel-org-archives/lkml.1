Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYLRXF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYLRXF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYLRXFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:05:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47539 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLRXFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:05:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <494AD72B.5050107@s5r6.in-berlin.de>
Date: Fri, 19 Dec 2008 00:05:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Subject: Re: [PATCH 2/4] firewire: cdev: use an idr rather than a linked list
 for resources
References: <20081124163728.GA5826@redhat.com> <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de> <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de> <tkrat.c14b3f03d12b2b29@s5r6.in-berlin.de> <494AD224.4000200@s5r6.in-berlin.de>
In-Reply-To: <494AD224.4000200@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Back to the drawing board.  This patch breaks FCP for dvgrab, kino,
> gscanbus

and testlibraw.  Before:
[...]
  - testing FCP monitoring on local node
    got fcp command from node 0 of 8 bytes: 01 23 45 67 89 ab cd ef
    got fcp response from node 0 of 8 bytes: 01 23 45 67 89 ab cd ef

[...]

After:
[...]
  - testing FCP monitoring on local node

[...]

This is the only test of testlibraw which fails now.
-- 
Stefan Richter
-=====-==--- ==-- =--==
http://arcgraph.de/sr/
