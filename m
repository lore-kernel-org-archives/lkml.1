Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXHCJsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXHCJsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbXHCJsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:48:03 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:44383 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757879AbXHCJsA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:48:00 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [REGRESSION] tg3 dead after s2ram
Date: Fri, 3 Aug 2007 11:47:37 +0200
User-Agent: KMail/1.9.7
cc: "David Miller" <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       "netdev" <netdev@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <1186002023.18322.7.camel@dell>
 <20070802.022317.66176729.davem@davemloft.net>
 <1186081829.18322.20.camel@dell>
In-Reply-To: <1186081829.18322.20.camel@dell>
MIME-Version: 1.0
Message-ID: <200708031147.38519.joachim.deguara@amd.com>
X-OriginalArrivalTime: 03 Aug 2007 09:47:38.0918 (UTC)
 FILETIME=[540A6C60:01C7D5B3]
X-WSS-ID: 6AAC26347CS4041811-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 21:10:29 Michael Chan wrote:
> Alternatively, we can also fix it by calling pci_enable_device() again
> in tg3_open().  But I think it is better to just always save and restore
> in suspend/resume.  bnx2.c will also require the same fix.
>
> Thanks Joachim for helping to debug this problem.  Please try this
> patch:

Patch works for me.


-Joachim



