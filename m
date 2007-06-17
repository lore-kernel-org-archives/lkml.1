Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXFVGNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXFVGNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXFVGNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:13:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:58898 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbXFVGNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:13:31 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Machine Check Exception: 0...04
Date: Sun, 17 Jun 2007 14:08:28 +0200
User-Agent: KMail/1.9.7
cc: "Linux Kernel Maillist" <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0706160948510.29686@filesrv1.baby-dragons.com>
In-Reply-To: <Pine.LNX.4.64.0706160948510.29686@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Message-ID: <200706171408.29521.joachim.deguara@amd.com>
X-OriginalArrivalTime: 22 Jun 2007 06:13:03.0075 (UTC)
 FILETIME=[64173330:01C7B494]
X-WSS-ID: 6A65B7FD1S41109967-03-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 22:40:53 Mr. James W. Laferriere wrote:
>  	Hello All ,  Does anoyone know howto identify a cause for these(*) ?
>  	Or of any tools to help in the identification of the cause ?
>  	So far the Machine checks only happen when I am running bonnie++ against
>  	my software raid6 array .

You should run mcelog to decode what the machine checks mean.  These do point 
to a hardware problem.   Just briefly judging from you description of when 
the MCEs happen I wonder if the power supply is getting maxed out driving all 
of those disks.  Either way, use mcelog to find out what the MCEs are first.

-Joachim


