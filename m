Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZIJTCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZIJTCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZIJTCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:02:38 -0400
Received: from claw.goop.org ([74.207.240.146]:41594 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZIJTCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:02:38 -0400
Message-ID: <4AA94D48.5010401@goop.org>
Date: Thu, 10 Sep 2009 12:02:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes
References: <4AA83F99.5040401@goop.org> <20090910051648.GA1335@elte.hu> <4AA93466.6020607@goop.org> <20090910172629.GA10689@elte.hu>
In-Reply-To: <20090910172629.GA10689@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/09 10:26, Ingo Molnar wrote:
> Looks like a nice cleanup. Mind sticking it into your next pull 
> request?
>   

The following changes since commit 2496afbf1e50c70f80992656bcb730c8583ddac3:
  Yang Xiaowei (1):
        xen: use stronger barrier after unlocking lock

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix
Jeremy Fitzhardinge (1):
      x86: split __phys_addr out into separate file

 arch/x86/mm/Makefile   |    4 +-
 arch/x86/mm/ioremap.c  |   72 +-----------------------------------------------
 arch/x86/mm/physaddr.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/physaddr.h |   10 ++++++
 4 files changed, 83 insertions(+), 73 deletions(-)
 create mode 100644 arch/x86/mm/physaddr.c
 create mode 100644 arch/x86/mm/physaddr.h

	J

