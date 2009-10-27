Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZJ0SUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZJ0SUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZJ0SUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:20:07 -0400
Received: from claw.goop.org ([74.207.240.146]:38865 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbZJ0SUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:20:06 -0400
Message-ID: <4AE739DA.20601@goop.org>
Date: Tue, 27 Oct 2009 11:20:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add	vsyscall	implementation
References: <4f079cd6-0872-4cb5-832b-ee6a46841192@default>
In-Reply-To: <4f079cd6-0872-4cb5-832b-ee6a46841192@default>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/09 10:29, Dan Magenheimer wrote:
> Is there any way for an application to conclusively determine
> programmatically if the "fast vsyscall" pvclock is functional
> vs the much much slower gettimeofday/clock_gettime equivalents?
>
> If not, might it be possible to implement some (sysfs?)
> way to determine this, that would also be backwards compatible
> to existing OS's that don't have pvclock+vsyscall supported?
>   

It would probably be simplest and most portable for the app to just
measure the performance of gettimeofday and see if it meets its needs.

    J
