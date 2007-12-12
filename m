Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbXLLMaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbXLLMaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXLLMar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:30:47 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:40263 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751052AbXLLMaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:30:46 -0500
X-Greylist: delayed 977 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 07:30:46 EST
Message-ID: <475FD0A1.3090304@voltaire.com>
Date: Wed, 12 Dec 2007 14:14:25 +0200
From: Or Gerlitz <ogerlitz@voltaire.com>
User-Agent: Thunderbird 1.4.1 (Windows/20051006)
MIME-Version: 1.0
To: Joachim Fenkes <FENKES@de.ibm.com>
CC: Roland Dreier <rdreier@cisco.com>, Arnd Bergmann <arnd@arndb.de>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Christoph Raisch <raisch@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
References: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com>
In-Reply-To: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 12:14:26.0863 (UTC) FILETIME=[8A196BF0:01C83CB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joachim Fenkes wrote:
> Roland Dreier <rdreier@cisco.com> wrote on 10.12.2007 22:47:37:

>> It's an optional device feature, so this should be OK
>> (although the iSER driver currently seems to depend on a device
>> supporting FMRs, which is probably going to be a problem with iWARP
>> support in the future anyway).

> I don't feel very well with removing code from the driver that iSER seems 
> to depend on. Are there plans to fix this in iSER?

What is the fix you suggest, to add a device query that tells you for 
which verbs the documentation does not apply? or enhance the code of the 
  map_phys_fmr verb within the ehca driver to return error if called 
from non-sleepable context?

Or.

