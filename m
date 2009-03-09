Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbZCIM4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbZCIM4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 08:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZCIM4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 08:56:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:32319 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZCIM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 08:56:24 -0400
Message-ID: <49B511E9.8030405@nokia.com>
Date: Mon, 09 Mar 2009 14:56:09 +0200
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] mm: tlb: unmap scalability
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 12:56:11.0028 (UTC) FILETIME=[6BD36D40:01C9A0B6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's a patch proposal to make unmap to scale linearly on architectures 
that implement tlb_start_vma() and tlb_end_vma(), by adding range 
parameters. See <http://marc.info/?l=linux-kernel&m=123610437815468&w=2> 
for the current problem.

The first patch only adds the new parameters. The second one changes the 
ARM architecture to use those parameters. A similar change should be of 
course made also for other architectures implementing those routines.

The patch was made for 2.6.29-rc7.

A.

