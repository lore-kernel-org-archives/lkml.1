Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbYBMSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbYBMSLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbYBMSLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:11:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765915AbYBMSLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:11:30 -0500
Message-ID: <47B3322A.2030607@redhat.com>
Date: Wed, 13 Feb 2008 13:08:42 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: lenb@kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 panics on boot
References: <20080213170310.GC19570@linux.vnet.ibm.com>
In-Reply-To: <20080213170310.GC19570@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> I am getting the following oops on bootup on 2.6.25-rc1
...
> I am booting using kexec with maxcpus=1. It does not have any problems
> with maxcpus=2 or higher.

Sounds like another (the same?) kexec cpu numbering bug.  Can you 
post/link the entire dmesg from both a cold boot and a kexec boot so we 
can compare?

	-- Chris
