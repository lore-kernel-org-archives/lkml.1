Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYCMKHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYCMKHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYCMKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:07:13 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:56732 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYCMKHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:07:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=Received:From:To:Date:MIME-Version:Subject:Message-ID:Priority:X-mailer:Content-type:Content-transfer-encoding:Content-description:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=VLDYmlY+ZkOPGPJrX3WNXquY2gQkg/Hylp1Cmfp/ypo1V7rEKSkepEi8te4+lRmwq
	XATapOg4xUdYiHlarWcYiGybTnKADxOMrNhRX9/MRki4gyrHehvDMQGolFlb/OSrCS2
	cCwUZXyi78ktAvpahQJQ91b2jMcecDh14UXEpZw=
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 11:14:35 +0100
MIME-Version: 1.0
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <47D90C9B.651.D93E8419@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
X-QM-Mark: email-qm2<15391135>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Mar 2008 at 10:13, Frantisek.Rysanek@post.cz wrote:
>
> My testbed server has passed some 5 loops of dd over the weekend.
> 
> Thanks for your help :-)
> 
> I'm installing a 64bit Fedora to give XFS another try...
> 
So I installed Fedora 8 64b, compiled a 64bit 2.6.24.2,
and XFS mounts without a word of objection :-)
even with my 32bit user-space on that old CD :-)

Interestingly, XFS even survives looped+parallel 
Bonnie++2 - only when I let it run overnight,
in the morning the box was stuck with a 
Machine Check Exception.
This is a dual Xeon Irwindale at 3 GHz, so far it's always
been rock-solid under 32bit operating systems.
Difficult for me to say if the CPU's indeed have a problem
or if this is some sorta compatibility bug...
Anyway it's unlikely to be a XFS-related issue.
I've checked the thermocouple paste on my heatsinks and I'll try 
again tonight with "nomce"...

Frank Rysanek

