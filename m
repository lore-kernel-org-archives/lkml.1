Return-Path: <linux-kernel-owner+w=401wt.eu-S964858AbXBLQSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbXBLQSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964867AbXBLQSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:18:37 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:58384 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858AbXBLQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=iZ6/hrRBye6+S6bELo3PCZqcz2jPgzcixDKnrprUbANyAgO3aVAifUBpovbuSuIvhq2vyLoxWWocvLS7ZlDoAEG0VeUzMVto4OK72xzNh4vtmLA35Rva5Z2Gqj/iJ0VCe+VzP8S4Z530qTLub9hudU6+gZUp4C4qbgy4pTY3Gr0=
Message-ID: <45D0934B.1060400@gmail.com>
Date: Mon, 12 Feb 2007 08:18:19 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: ris <ris@elsat.net.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: High CPU usage with sata_nv
References: <20070115164541.M22367@elsat.net.pl> <20070115165432.M87238@elsat.net.pl> <20070115182642.GA18374@slug> <20070115222320.M55059@elsat.net.pl> <45B43241.1070301@gmail.com> <loom.20070211T232847-590@post.gmane.org> <45D00DF7.6090605@gmail.com> <loom.20070212T150936-751@post.gmane.org>
In-Reply-To: <loom.20070212T150936-751@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ris wrote:
> Tejun Heo <htejun <at> gmail.com> writes:
> 
>> iowait != cpu busy.  Your cpu idleness stays above 80%.
>>
> 
> 
> Ok ...... but one of my CPU core are at 99% usage ....
> htop report this ....
> 
> So how to solve this problem ?

The red part of cpu usage bar represents 'iowait' not cpu usage.  Fire 
up both top and htop and pay attention to 'Wa' value in top.  You're 
just confused about how the graph is drawn in htop, nothing wrong with 
your system.

-- 
tejun
