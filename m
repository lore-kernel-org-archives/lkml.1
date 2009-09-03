Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZICWGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZICWGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbZICWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:06:36 -0400
Received: from claw.goop.org ([74.207.240.146]:36033 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbZICWGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:06:35 -0400
Message-ID: <4AA03DE8.40706@goop.org>
Date: Thu, 03 Sep 2009 15:06:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, 544145@bugs.debian.org,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org>
In-Reply-To: <20090903220252.GA19309@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/09 15:02, Bastian Blank wrote:
> AFAIK only AMD support the syscall instruction, so yes it is an AMD
> machine. And yes, disabling the only thing that make the glibc call this
> instruction works around it.
>   

The bug actually appears to be in xen_sysret32, ie the crash happens on
the way out of the kernel.

    J
