Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYC1LcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYC1LcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYC1Lb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:31:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:25048 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbYC1Lb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JnaTA+M3N+tRLcelrq47Ryb3tqbHqjaduXmtFdZJUzKPfQmdMkEYLSOUciUiMAAteuzMgLp2FwWcxEXQb5K6YX5mcdnwCy4PSxOqoXimJqTO+FTGCmQvHB0tbgPEyGiA3ihpWsPqrm2d/r3g/3qWKBE8Jh0SuOus1NbJVvif5lg=
Message-ID: <47ECD715.90507@gmail.com>
Date: Fri, 28 Mar 2008 12:31:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
References: <47ECD0CF.1020003@gmail.com> <87y783jdjo.fsf@basil.nowhere.org>
In-Reply-To: <87y783jdjo.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2008 12:25 PM, Andi Kleen wrote:
> However the new standard way to do this is to not 
> add new stuff into compat_ioctl.c, but define ->compat_ioctl
> entry points in the low level drivers (and ideally converted
> them to ->unlocked_ioctl too while you're at it)

Andi, the problem here is, that v4l has only open in fops which in turn changes 
fops to the driver's one, so this would mean change all the drivers in v4l...

I second the converting to unlocked_ioctl and compat_ioctl in longer term (for 
new drivers as a merging rule), but wouldn't be feasible to add them to compat 
ioctl for now?
