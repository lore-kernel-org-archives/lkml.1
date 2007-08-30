Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbXH3V22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbXH3V22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXH3V2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:28:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35123 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbXH3V2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:28:18 -0400
Date: Thu, 30 Aug 2007 16:28:16 -0500
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: jschopp <jschopp@austin.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Thomas Q Klein <tklein@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
Message-ID: <20070830212816.GA4263@austin.ibm.com>
References: <46D5BBFA.5060200@austin.ibm.com> <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:00:56PM +0200, Joachim Fenkes wrote:
> 
> Plus, I rather like using 
> the full_name since it also contains a descriptive name as opposed to 
> being just nondescript numbers, helping the layman (ie user) to make sense 
> out of a dev_id.

Yes, well, but no. The location code is useful as a geographical
location: slots and devices are physically labelled with stickers 
so you can tell which is which.  Handy when you have to unplug stuff. 
By contrast, the device-tree full_name is mostly just gobldy-gook, 
with some crazy phb numbering in there that, after four years of 
staring at them, I still can't reliably do anything useful with.  
Location codes are nice. 

--linas
