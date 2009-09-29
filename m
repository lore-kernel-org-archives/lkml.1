Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZI2K3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZI2K3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZI2K3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZI2K27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:28:59 -0400
Message-ID: <4AC1E16B.1090406@redhat.com>
Date: Tue, 29 Sep 2009 12:28:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Stack corruption on 2.6.31 [with KVM]
References: <200909270816.10832.con@kolivas.org> <200909292018.12989.kernel@kolivas.org>
In-Reply-To: <200909292018.12989.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 12:18 PM, Con Kolivas wrote:
> Resending with a couple of extra CCs.
>
> Only extra details I guess were debian stable with kvm that reports itself as:
> QEMU PC emulator version 0.9.1 (kvm-72), Copyright (c) 2003-2008 Fabrice
> Bellard
>
> Note that I get this stack corruption *every time*, and it must be with
> the -no-kvm option.
>
>    

-no-kvm means kvm is not in use, so unlikely to be the cause of the problem.

Please send to qemu-devel@nongnu.org, but first try with qemu 0.11.0.

-- 
error compiling committee.c: too many arguments to function

