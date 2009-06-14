Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbZFNS4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbZFNS4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZFNS4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 14:56:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34579 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZFNS4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 14:56:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A3547DD.2010809@s5r6.in-berlin.de>
Date: Sun, 14 Jun 2009 20:56:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: dma-debug: check_for_stack background?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it took a while but I finally noticed that the DMA debug facility warns 
about mappings of on-stack memory.  What's the problem with that?  Are 
there architectures which don't support such mappings, or is it a 
question of caution not to DMA-map the stack?
-- 
Stefan Richter
-=====-==--= -==- -===-
http://arcgraph.de/sr/
