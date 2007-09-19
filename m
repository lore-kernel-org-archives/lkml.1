Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbXISIx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbXISIx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXISIxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:53:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36000 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766AbXISIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:53:19 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 19 Sep 2007 10:52:58 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: one driver and 4 instances with different
 parameters
Message-ID: <20070919085258.GA6640@alberich.amd.com>
References: <016a01c7fa89$ff51e850$b4fefea9@andrey>
MIME-Version: 1.0
In-Reply-To: <016a01c7fa89$ff51e850$b4fefea9@andrey>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2007 08:52:55.0508 (UTC)
 FILETIME=[78641140:01C7FA9A]
X-WSS-ID: 6AEE3CFA0X87896048-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 08:54:58AM +0200, Andrey Kamchatnikov wrote:
> I have one driver, but I need to run 4 instances of it (I run insmod with different 
> parameters) .
> 
> But when I try to install the second driver I've got an error, that driver with this name 
> exists.

It might work using modprobe's "--name"-option:

  # modprobe -o foo driver
  # modprobe -o bar driver


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



