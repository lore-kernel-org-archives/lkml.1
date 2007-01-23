Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbXAWB4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbXAWB4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXAWB4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:56:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbXAWB4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:56:32 -0500
Message-ID: <45B569A4.3010006@redhat.com>
Date: Mon, 22 Jan 2007 20:49:24 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Balbir Singh <balbir@in.ibm.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> With the proposed schemd you would have to move pages between lists if 
> they are mapped and unmapped by a process. Terminating a process could 
> lead to lots of pages moving to the unnmapped list.

That could be a problem.

Another problem is that any such heuristic in the VM is
bound to have corner cases that some workloads will hit.

It would be really nice if we came up with a page replacement
algorithm that did not need many extra heuristics to make it
work...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
