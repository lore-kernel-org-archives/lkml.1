Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZJOTUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZJOTUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761693AbZJOTT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:19:59 -0400
Received: from claw.goop.org ([74.207.240.146]:44181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761606AbZJOTT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:19:58 -0400
Message-ID: <4AD775BA.30704@goop.org>
Date: Thu, 15 Oct 2009 12:19:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Subject: Re: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
References: <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>
In-Reply-To: <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/09 06:27, Dan Magenheimer wrote:
> I understand but you are now essentially emulating a
> reliable platform timer with a potentially unreliable
> (but still high resolution) per-CPU timer AND probably
> delivering that result to userland.
>
> Read_tsc should only be used if either CONSTANT_TSC
> or TSC_RELIABLE is true, so read_tsc is guaranteed
> to be monotonically-strictly-increasing by hardware
> (and enforced for CONSTANT_TSC by check_tsc_warp
> at boot).
>   

read_tsc clearly isn't expected to produce absolutely globally monotonic
results; if it were then the check wouldn't be necessary.

    J
