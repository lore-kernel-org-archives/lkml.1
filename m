Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbXKNSSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbXKNSSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXKNSS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:18:28 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52412 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbXKNSS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:18:27 -0500
X-IronPort-AV: E=Sophos;i="4.21,417,1188802800"; 
   d="scan'208";a="516535"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Question about free/used memory on Linux
Date: Wed, 14 Nov 2007 10:18:24 -0800
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B85A3@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <473AE2CC.4080609@draigBrady.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about free/used memory on Linux
Thread-Index: Acgmtamc0cGLXK3sSdKUlN0PFk6oWwANP9/Q
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com> <471C3A17.5020400@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B859E@xmb-sjc-214.amer.cisco.com> <473AE2CC.4080609@draigBrady.com>
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: =?iso-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Cc: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Nov 2007 18:18:24.0904 (UTC) FILETIME=[BF050880:01C826EA]
Authentication-Results: sj-dkim-1; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Padraig.

Any idea how to get the size of running linux kernel ?

Ravi 

-----Original Message-----
From: Pádraig Brady [mailto:P@draigBrady.com] 
Sent: Wednesday, November 14, 2007 3:58 AM
To: Ravinandan Arakali (rarakali)
Cc: Vaidyanathan Srinivasan; Linux Kernel
Subject: Re: Question about free/used memory on Linux

Ravinandan Arakali (rarakali) wrote:
> Hi Vaidy,
> What do you think is the right way to get the memory usage of a 
> process, I mean the actual physical memory used ? Basically, I'm 
> interested in the incremental cost of a process, which means, I don't 
> want to include the text segments of shared libraries which would 
> remain even after the process is killed (since it would be used by 
> other processes).
> 
> Is the RSS field of "ps aux" command the right one or use "pmap" 
> command and look at the "writeable" segments ?

I already commented on this thread with a python script for reporting RAM usage for programs.

RSS = Private and Shared Resident pages.
You can get the shared value for a process from /proc/$$/smaps (as is done in the script)

Pádraig.
