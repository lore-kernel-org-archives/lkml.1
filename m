Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZDFSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZDFSXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZDFSXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:23:13 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:62285 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZDFSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rxalVobrEdehSCgYU4RobI+V6Kb28fznuh/xGjEc05YYTMxoEqVwJkMCEhHeswaEqt
         3nWlmB/hg9lgTFcruAHJCku94BF5NJeRDTj6UnvkkSWkJX7/dLaHbIjs7RF+3k4GjrDH
         F9rQn6fy3BuHQmbD/OWGPYOgVycf1MAdkiR5w=
Message-ID: <49DA489E.1030801@gmail.com>
Date: Mon, 06 Apr 2009 20:23:26 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com> <49D9D4D8.2020608@kernel.org>
In-Reply-To: <49D9D4D8.2020608@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2009 12:09 PM, Tejun Heo wrote:
>
>> Will the fix naturally make its way into the mainline kernel, or is
>> there any extra debugging/testing I can help with?
>>     
>
> Well, the problem is the debug patch doesn't actually do anything
> other than printing out messages.  It could be that the problem is
> timing dependent (which is likely anyway).  You still can reporduce
> the problem with the patch, right?
>   
Heh? You provided two patches, with the last one you said:
> Strange.  Maybe IO commands are getting through while the sdev is
> still in quiesce state?  Can you please repeat the test with the
> attached patch?
>   
With the latter, I have not encountered the original problem i.e. any
severe EXT4 corruption again, not in 2.6.29 and not in 2.6.29.1.

Do I also need to try the last patch without any debugging messages?

cheers
Niel
