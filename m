Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZGPGpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZGPGpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZGPGpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:45:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55167 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZGPGpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:45:05 -0400
Message-ID: <4A5ECC09.3010405@garzik.org>
Date: Thu, 16 Jul 2009 02:43:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.4.rc1
References: <7vmy75bg2f.fsf@alter.siamese.dyndns.org> <4A5EA598.5050801@garzik.org> <7v3a8xb0lz.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7v3a8xb0lz.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Is there some sort of guide to the new best practices for handling
>> trees such as git.kernel.org, where one pushes into "foo.git"
>> directly, and there is no checked-out source code at all?
> 
> I think old repositories will be helped if you add
> 
> 	[core]
>         	bare
> 
> to their foo.git/config files.

Thanks.  What about cloning new repositories?  Real world example:

Local workstation has /spare/repo/cld/.git repository, with checked-out 
working tree.

I want to publish this tree to the world via a *.kernel.org-like system, 
so my task is to

	scp -r /spare/repo/cld/.git remote.example.com:/pub/scm/cld.git

but if I do this with scp, then future pushes to 
remote.example.com:/pub/scm/cld.git emit the warning about updating the 
currently checked-out branch -- even though there are no checked-out 
files.  The checked-out files were not copied in the scp.

Regards,

	Jeff



