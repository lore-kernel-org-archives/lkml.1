Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965790Ab0BZTH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:07:28 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:30205 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965726Ab0BZTH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:07:27 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>, Hank Janssen <hjanssen@microsoft.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Problem with auto-detecting a HV environment from within Linux
Thread-Topic: Problem with auto-detecting a HV environment from within Linux
Thread-Index: AQHKtjnpPG+DB1+VDUmGCDmANJRAY5HXEhsAgACJl4D//4hyAIAA0+OA//+Bz6CAAJoqAIAAGKGAgAAL24CAAITkQA==
Date: Fri, 26 Feb 2010 19:07:14 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF725B6A6D15@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225230639.GB20900@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100226004646.GA31483@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56212EDCD14@TK5EX14MBXC116.redmond.corp.microsoft.com>
 <20100226025721.GA10310@kroah.com>
In-Reply-To: <20100226025721.GA10310@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, February 25, 2010 9:57 PM
> In looking at the second patch again, I think you will need to put some
> spaces in the DMI strings to get it to match up properly.  Look at what
> the files in:
> 	/sys/class/dmi/id/
> look like exactly to get it to line up.  The module id stuff strips
> spaces out, so I can't get the real value there.

Thanks for your help! I have applied the two patches -- auto loading of hv_vmbus works fine after a space was inserted into the DMI strings ("Microsoft Corporation", "Virtual Machine").

Also, according to our Hyper-V team, we have no plan to change the virtual VGA card id and DMI info.

Thanks,

- Haiyang
