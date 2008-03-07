Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYCGKlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYCGKlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYCGKky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:40:54 -0500
Received: from smtp.seznam.cz ([77.75.72.43]:55456 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754274AbYCGKkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:40:53 -0500
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2008 11:48:10 +0100
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <47D12B7A.29851.BA771AB4@localhost>
In-reply-to: <87hcfig9tr.fsf@basil.nowhere.org>
References: <47D0EA6B.18428.A235AEC4@Frantisek.Rysanek.post.cz>
X-mailer: Pegasus Mail for Windows (4.21c)
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Mar 2008 at 10:30, Andi Kleen wrote:
[...snip...]
> BTW your problems mostly sound like driver issues. Some drivers 
> (and some controller firmwares) have problems with large block numbers
> 
thanks for that hint, I'll investigate that too.

The HBA is a Qlogic QLA-2460. Based on some past experience with 
other brands of FC HBA's, I tend to swear on Qlogic as the reference 
implementation of FC hardware.

The driver I've tried so far is the vanilla version in 2.6.22.6 and 
2.6.24.2. The firmware that I load at runtime is something I've 
downloaded from Qlogic web maybe four months ago... time to update my 
firmware :-)

Frank Rysanek
