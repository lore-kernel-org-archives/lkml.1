Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZIXRrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZIXRrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZIXRrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:47:11 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:47194 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZIXRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:47:10 -0400
Message-ID: <4ABBB09B.8070009@librato.com>
Date: Thu, 24 Sep 2009 13:47:07 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 4/9]: Add target_pid parameter to alloc_pidmap()
References: <20090924165548.GA16586@us.ibm.com> <20090924170131.GD16989@us.ibm.com>
In-Reply-To: <20090924170131.GD16989@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> 
> Subject: [RFC][v7][PATCH 4/9]: Add target_pid parameter to alloc_pidmap()
> 
> With support for setting a specific pid number for a process,
> alloc_pidmap() will need a 'target_pid' parameter.
> 
> Changelog[v6]:
> 	- Separate target_pid > 0 case to minimize the number of checks needed.
> Changelog[v3]:
> 	- (Eric Biederman): Avoid set_pidmap() function. Added couple of
> 	  checks for target_pid in alloc_pidmap() itself.
> Changelog[v2]:
> 	- (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
> 	  actually checks for 'pid <= 0' for completeness).
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>

