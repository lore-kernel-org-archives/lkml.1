Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZB0WXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZB0WXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZB0WXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:23:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36039 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZB0WXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:23:14 -0500
Message-ID: <49A867CD.70807@redhat.com>
Date: Fri, 27 Feb 2009 17:23:09 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080915)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: filesystem time stamp resolution
References: <49A7232C.6050808@redhat.com> <87r61k2rl4.fsf@basil.nowhere.org> <49A862CD.2000409@redhat.com>
In-Reply-To: <49A862CD.2000409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Andi Kleen wrote:
>   
>> One issue is network file systems. The kernel has no idea what a
>> remote NFS (or other network) file system will support, because it
>> depends on the file system on the remote server.
>>     
>
> Hence my point in the initial mail saying this would be nice to have a
> solution for.
>
> Possibly some of the people working on the next NFS protocol revision
> (or similar protocols) read this and add appropriate requests to the
> protocol.

The NFSv3 and NFSv4 protocols already contain such support.
NFSv2 implementations which also support the MOUNTv2
protocol can also support this facility too, I believe.

       ps
