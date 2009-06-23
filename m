Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZFWAES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZFWAES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZFWAEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:04:09 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35598 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZFWAEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A5iUnrV3QqCUWhLgCHTEX5o8ybbG2bMN06+3qrWm5jQKm4IA5xITgsLROEu3e2p7zQ
         gAhcpbAHpzpf8iPg/3SEcGch7vnd1z7Ebu5Ni/IfHOqVPrjZJWRmdz35N6PpbaJliWYh
         g6VndYAOmsz8EMb5aCSYZ1xoDfpZj+Si/U7tU=
Message-ID: <4A401C19.8090102@gmail.com>
Date: Mon, 22 Jun 2009 18:04:41 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Raz <raziebe@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Re: Permission to use list.h and atomic.h in user space
References: <5d96567b0906220510q32d0280diec9a2179ed37216e@mail.gmail.com> 	<20090622153701.1012ca3c@t61.ukuu.org.uk> <5d96567b0906220644p4c412163m26d7cb16e6e5c58d@mail.gmail.com>
In-Reply-To: <5d96567b0906220644p4c412163m26d7cb16e6e5c58d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 07:44 AM, Raz wrote:
> Hello
> May I have permission to use atomic64.h ,atomic32.h and list.h in a
> proprietary software ?
> I do not know who the authors are.
> Thank you
> Raz

You would likely have to basically track down everyone who has ever 
contributed to those files and get their permission, which seems 
unlikely. So the short answer is almost certainly no.

With newer gcc there are atomic built-in functions which will likely do 
what you want for the atomic ops at least..
