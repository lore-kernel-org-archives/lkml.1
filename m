Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0CLNYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:24:06 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:63927 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932817Ab0CLNYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:24:04 -0500
From: Frans Pop <elendil@planet.nl>
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: tcpdump broke in 2.6.34-rc1
Date: Fri, 12 Mar 2010 14:23:59 +0100
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LSU.2.01.1003120037050.22042@obet.zrqbmnf.qr>
In-reply-To: <alpine.LSU.2.01.1003120037050.22042@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003121424.00868.elendil@planet.nl>
X-OriginalArrivalTime: 12 Mar 2010 13:24:01.0597 (UTC) FILETIME=[479406D0:01CAC1E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> I am currently on 2.6.34-rc1 and found that tcpdump no
> longer works (dies with setsockopt: invalid argument). Bisect-narrowed
> it down to somewhere between

Probably the same as http://lkml.org/lkml/2010/3/9/439, which has an exact 
bisect.

Has a follow-up that it's fixed by
http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=1162563f82b434e3099c9e6c1bbdba846d792f0d

Cheers,
FJP
