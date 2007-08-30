Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbXH3Ugp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbXH3Ugp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXH3Ugg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:36:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44590 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXH3Ugf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:36:35 -0400
Message-ID: <46D72A4E.6060106@austin.ibm.com>
Date: Thu, 30 Aug 2007 15:36:30 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Joachim Fenkes <FENKES@de.ibm.com>
CC: Nathan Lynch <ntl@pobox.com>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
References: <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
In-Reply-To: <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There are currently two GX devices, eHCA and eHEA, which both reside 
> beneath the root node - this is required by architecture for those 
> devices. Unless they invent a device called 
> "supercalifragilisticexpialidocious", devices in the root note will have a 
> full_name of less than 31 chars. Even in that case, the truncation occurs 
> at the beginning, so the @xxx part that makes the nodes unique will stay 
> in place.
> 

OK, didn't realize it had to be beneath the root node, and that the 
truncation truncated the front and not the back.  I would have done it 
differently, but this should work.

Acked-by: Joel Schopp <jschopp@austin.ibm.com>

