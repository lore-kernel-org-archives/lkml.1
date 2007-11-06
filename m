Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbXKFTVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbXKFTVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXKFTV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:21:28 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55831 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbXKFTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:21:27 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Tue, 6 Nov 2007 20:20:54 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       gcosta@redhat.com, mingo@elte.hu, tglx@linutronix.de, travis@sgi.com
Subject: Re: + x86-show-cpuinfo-only-for-online-cpus.patch added to -mm
 tree
Message-ID: <20071106192026.GE15369@alberich.amd.com>
References: <20071101193932.8A44D432BDC@localhost>
 <86802c440711011531u5a8a4872r3b4c33e5fd0fd0c9@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <86802c440711011531u5a8a4872r3b4c33e5fd0fd0c9@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Nov 2007 19:20:29.0640 (UTC)
 FILETIME=[17D4A480:01C820AA]
X-WSS-ID: 6B2E611524S1595827-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 03:31:23PM -0700, Yinghai Lu wrote:
> 
> wonder if could change
> 
> >       if (!cpu_online(c->cpu_index))
> >               return 0;
> 
> ==>
> 
> >       if (c->cpu_index >= NR_CPUS)
> >               return 0;
> 
> and add another entry for every cpu
> online : 1 when it is enabled
> or online : 0 when it is disabled by /sys/devices/system/cpuX/online.

No, I don't think that would be a good idea. It would change
the usual behaviour of that interface (to display only CPUs that
are "up and running".) 


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



