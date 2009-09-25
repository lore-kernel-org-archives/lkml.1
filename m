Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZIYXWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZIYXWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZIYXWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:22:11 -0400
Received: from claw.goop.org ([74.207.240.146]:60558 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZIYXWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:22:10 -0400
Message-ID: <4ABD50A5.5000309@goop.org>
Date: Fri, 25 Sep 2009 16:22:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: unify sys_iopl
References: <4ABD3EC2.1020104@goop.org> <73c1f2160909251556g40f3c5b1o1c29b7f012912873@mail.gmail.com>
In-Reply-To: <73c1f2160909251556g40f3c5b1o1c29b7f012912873@mail.gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/09 15:56, Brian Gerst wrote:
> The correct fix is to move set_iopl_mask into do_iopl.  sys_iopl
> should only be a wrapper around do_iopl to manage the different
> calling convention used by 32-bit and 64-bit.
>   

The patch eliminates that distinction, so I guess do_iopl should really
be folded into sys_iopl (though the compiler effectively does that
anyway by inlining it).

    J
