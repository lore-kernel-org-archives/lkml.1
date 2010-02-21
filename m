Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0BUJxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 04:53:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab0BUJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 04:53:17 -0500
Message-ID: <4B81028A.7080909@redhat.com>
Date: Sun, 21 Feb 2010 11:53:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] KVM: SVM: Don't call instruction emulator for invd
 and wbinvd
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com> <1266592990-8911-12-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1266592990-8911-12-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2010 05:23 PM, Joerg Roedel wrote:
> There is an intercept for WBINVD and INVD in SVM so we don't
> need the instruction emulator. The primary reason is that
> the current instruction emulator fails to emulate these
> instructions and the rip is not advanced.
>    

The bios (at least bochs bios) does have wbinvd, so this ought to work.


-- 
error compiling committee.c: too many arguments to function

