Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbXLGWHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbXLGWHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXLGWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:07:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:7999 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXLGWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:from:subject:date:to:x-mailer:sender;
        b=orQ42Kr30Ju9mmsyTSJDj+gKhjv12ML5oh3JsP2IHEO0aoP6ezfmF0iL8Krt9m8ZVUXef/tWCJBKAMe824y/1Be4c23H8WYT1JOxyUTF2CduePyhsbYmfCIRfnKoafb4Vtjayl+6kI85Nh41pN0Apw1NVPx5oMU6slmzywA89PY=
In-Reply-To: <11272.1197056185@turing-police.cc.vt.edu>
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712071353.11654.a1426z@gawab.com> <m3prxiu3oo.fsf@roke.D-201> <200712072204.48410.a1426z@gawab.com> <11272.1197056185@turing-police.cc.vt.edu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1D40FF54-64FD-4507-8E5D-02A01F2DD8EB@vicaya.com>
Cc: Al Boldi <a1426z@gawab.com>, Jakub Narebski <jnareb@gmail.com>,
       Andreas Ericsson <ae@op5.se>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Luke Lu <git@vicaya.com>
Subject: Re: git guidance
Date: Fri, 7 Dec 2007 14:07:29 -0800
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007, at 11:36 AM, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Dec 2007 22:04:48 +0300, Al Boldi said:
>
>> Because WORKFLOW C is transparent, it won't affect other  
>> workflows.  So you
>> could still use your normal WORKFLOW B in addition to WORKFLOW C,  
>> gaining an
>> additional level of version control detail at no extra cost other  
>> than the
>> git-engine scratch repository overhead.
>>
>> BTW, is git efficient enough to handle WORKFLOW C?
>
> Imagine the number of commits a 'make clean; make' will do in a  
> kernel tree, as
> it commits all those .o files... :)

My guess is that Al is not really a developer (product management/ 
marketing?), what he has in mind is probably not an SCM but a backup  
system a la Mac's time machine or Netapp's snapshots that also  
support disconnected commits. I think that git could be a suitable  
engine for such systems, after a few tweaks to avoid compressing  
already compressed blobs like jpeg, mp3 and mpeg etc.

__Luke
