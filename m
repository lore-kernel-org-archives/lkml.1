Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZLUQlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZLUQlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZLUQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:41:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZLUQlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:41:08 -0500
Message-ID: <4B2FA4F2.8000401@redhat.com>
Date: Mon, 21 Dec 2009 18:40:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws>
In-Reply-To: <4B2FA42F.3070408@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 06:37 PM, Anthony Liguori wrote:
> Since virtio-pci supports MSI-X, there should be no IO exits on 
> host->guest notification other than EOI in the virtual APIC.  This is 
> a light weight exit today and will likely disappear entirely with 
> newer hardware.

I'm working on disappearing EOI exits on older hardware as well.  Same 
idea as the old TPR patching, without most of the magic.

-- 
error compiling committee.c: too many arguments to function

