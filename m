Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZDPPiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZDPPiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZDPPhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:37:53 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:62596 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZDPPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:37:53 -0400
Message-ID: <49E750CA.4060300@nortel.com>
Date: Thu, 16 Apr 2009 09:37:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: how to tell if arbitrary kernel memory address is backed by physical
 memory?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2009 15:37:49.0419 (UTC) FILETIME=[4C36F3B0:01C9BEA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Quick question to the memory management folks.

Is there a portable way to tell whether a particular virtual address in 
the lowmem address range is backed by physical memory and is readable?

For background...we have some guys working on a software memory scrubber 
for an embedded board.  The memory controller supports ECC but doesn't 
support scrubbing  in hardware.  What we want to do is walk all of 
lowmem, reading in memory.  If a fault is encountered, it will be 
handled by other code.

Thanks,

Chris
