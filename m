Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbXF1O1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbXF1O1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXF1O1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:27:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbXF1O1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:27:25 -0400
Message-ID: <4683C539.4070202@redhat.com>
Date: Thu, 28 Jun 2007 10:27:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO
 page retirement policy
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1> <4681D37E.2020706@redhat.com> <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com> <4681E52A.8030300@redhat.com> <Pine.LNX.4.64.0706262127300.26540@alien.or.mcafeemobile.com> <20070628061911.GA16986@hexapodia.org>
In-Reply-To: <20070628061911.GA16986@hexapodia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson wrote:

> That said, I think I like the idea of MAP_NOZERO.  Could it be
> generalized to some kind of "free pool" rather than keyed off of uid?

Good idea.  At exec() time the new mm can inherit the "free pool"
pointer that the parent process points to, when nothing changes.

Certain events can cause a process to need another "free pool",
for example changing the UID, changing security context or
changing CPU/NUMA node binding.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
