Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZKLPpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZKLPpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZKLPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:45:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:49116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZKLPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=imMTLng3J6LnvGXco1BmrGGTNE1+hnkN5f7C8j2ClBMD/Nx5bZ8ExJ6UsNFSWjaONU
         aaIFGbMvLOCKxoSBdo8Nj3oMZ747usVyCnPtCOPzeWJzAb1Q91c0fv1jrNphr9n9j+2O
         wKCKA4aiUPZYVa3cvrJ2Gb0A2LN5QixMcaIOE=
Message-ID: <4AFC2D86.9060406@gmail.com>
Date: Fri, 13 Nov 2009 00:45:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu> <4AFBDF43.3010703@kernel.org> <20091112103639.GB24684@elte.hu> <4AFBEA4B.4070100@kernel.org> <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain> <4AFC2A17.9030706@kernel.org>
In-Reply-To: <4AFC2A17.9030706@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/13/2009 12:30 AM, Tejun Heo wrote:
>> 'checkpatch' is the major reason for them, but I think we've fixed 
>> checkpath long ago to not warn about long lines if they are due to a long 
>> string.

It still warns...  :-(

 WARNING: line over 80 characters
 #11: FILE: mm/percpu.c:1100:
 +                               err = "failed to extend area map of reserved chunk";

-- 
tejun
