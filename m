Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbXFSRBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbXFSRBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbXFSRBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:01:48 -0400
Received: from main.gmane.org ([80.91.229.2]:51595 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbXFSRBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:01:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jakub Narebski <jnareb@gmail.com>
Subject: Re: Versioning file system
Followup-To: gmane.comp.version-control.git
Date: Tue, 19 Jun 2007 18:52:22 +0200
Organization: At home
Message-ID: <f591k5$odb$2@sea.gmane.org>
References: <OF7FA807A1.64C0D5AF-ON882572FE.0061B34C-882572FE.00628322@us.ibm.com> <6E9A6F9E-8948-40F2-9129-1F1491D49D83@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-89-229-25-173.torun.mm.pl
Mail-Copies-To: Jakub Narebski <jnareb@gmail.com>
User-Agent: KNode/0.10.2
Cc: git@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Jun 18, 2007, at 13:56:05, Bryan Henderson wrote:

>>> The question remains is where to implement versioning: directly in  
>>> individual filesystems or in the vfs code so all filesystems can  
>>> use it?
>>
>> Or not in the kernel at all.  I've been doing versioning of the  
>> types I described for years with user space code and I don't  
>> remember feeling that I compromised in order not to involve the  
>> kernel.
>>
>> Of course, if you want to do it with snapshots and COW, you'll have  
>> to ask where in the kernel to put that, but that's not a file  
>> versioning question; it's the larger snapshot question.
> 
> What I think would be particularly interesting in this domain is  
> something similar in concept to GIT, except in a file-system
[cut]

How it relates to ext3cow versioning (snapshotting) filesystem,
for example? ext3cow assumes linear history, which simplifies things
a bit.

-- 
Jakub Narebski
Warsaw, Poland
ShadeHawk on #git


