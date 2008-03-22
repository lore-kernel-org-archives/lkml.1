Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYCVKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYCVKU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 06:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCVKUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 06:20:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45908 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYCVKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 06:20:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E4DD50.9050706@s5r6.in-berlin.de>
Date: Sat, 22 Mar 2008 11:20:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: catch self_id_count == 0
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de> <tkrat.00038248cbf40b77@s5r6.in-berlin.de> <tkrat.a46eb70f34367db6@s5r6.in-berlin.de> <tkrat.463115f5f3763a98@s5r6.in-berlin.de> <tkrat.8492f68de2af250b@s5r6.in-berlin.de> <tkrat.8f4d95b45b232823@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8f4d95b45b232823@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> fw_core_handle_bus_reset() incorrectly relied on the assumption that
> self_id_count > 0.

Even though
     firewire: insist on successive self ID complete events
     firewire: fw-ohci: add self ID error check
     firewire: fw-ohci: catch self_id_count == 0
didn't fix any of Jarod's weird setups, I plan on submitting these 
patches nevertheless (after 2.6.25) because they IMO fix real 
possibilities for panics in the topology code.
-- 
Stefan Richter
-=====-==--- --== =-==-
http://arcgraph.de/sr/
