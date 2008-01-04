Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYADC5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYADC5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYADC50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:57:26 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32502 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbYADC5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:57:25 -0500
Date: Thu, 03 Jan 2008 20:56:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA kernel-buffered read VERY slow (not raid,
 Promise TX300 card); 2.6.23.1(vanilla)
In-reply-to: <477D9D66.3080502@tlinx.org>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Message-id: <477DA05F.4080503@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.o9uy6Qaq3PtHs2Z9lAKGUKvD85I@ifi.uio.no>
 <fa.1kDEq2SPE3FqpM5Mfw9CVGbvVdY@ifi.uio.no>
 <fa.hIZ5+XhGRugySB/HuLxr5qd6gAY@ifi.uio.no>
 <fa.iefWPg3R6g5Pnm/ktSCK9XWVFVw@ifi.uio.no>
 <fa.FhpaleM/osLTMJ85/PuxjxyJeGI@ifi.uio.no>
 <fa.MP5rgMp4TS2+Cfemd/uFOQOuquQ@ifi.uio.no> <477D9B6E.7060000@shaw.ca>
 <477D9D66.3080502@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Robert Hancock wrote:
>>
>> Looks like the drive reports ERR/ABRT (command aborted), meaning it 
>> likely doesn't support those commands.
>>
> ---
>    Except the PATA version of the drive does (same capacity, & other 
> specs).  Seagate would
> disable "advanced" features for SATA but leave them for the older 
> technology?  Possible,
> but doesn't seem likely.

If this is a Seagate, I believe that they don't have AAM enabled on any 
of their newer drives (something about a lawsuit for patent infringement 
on that feature, or something). Quite likely they don't support that 
power management command, either.
