Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbXBFWEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbXBFWEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965477AbXBFWEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:04:32 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4924 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965370AbXBFWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:04:31 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <45C8FC19.1020109@amd.com>
Date: Tue, 06 Feb 2007 23:07:21 +0100
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070206)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86-64 ext2/ext3 datestamp problem
References: <45C8F419.5040103@amd.com> <45C8F7E6.6060009@zytor.com>
 <45C8F9DA.6040906@amd.com> <45C8FA62.7000308@zytor.com>
In-Reply-To: <45C8FA62.7000308@zytor.com>
X-OriginalArrivalTime: 06 Feb 2007 22:04:16.0669 (UTC)
 FILETIME=[BE6C84D0:01C74A3A]
X-WSS-ID: 69D624EE2MC7280779-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Markus Rechberger wrote:
>> My debian system's coreutils package only allows dates between 1902 and
>> 2038, but it might be interesting to get that right if it's wrong.
>>
>> touch (GNU coreutils) 5.97 just says invalid dateformat to 2050-01-01
>
> Lemme guess, you're on a 32-bit system...
>

I have both here, 64 and 32bit
If I touch a file with 1905 on my 32bit system and remount the disk the
date will remain at 1905 without any patch.

Markus


