Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbYENRm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbYENRm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYENRmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:42:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbYENRmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:42:49 -0400
Message-ID: <482B242D.7040801@redhat.com>
Date: Wed, 14 May 2008 14:41:01 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: 2.6.26-rc1 sound regression
References: <20080514130742.GA28872@erig.dyndns.org>
In-Reply-To: <20080514130742.GA28872@erig.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Hi,
> 
> my sound stops working with 2.6.26-rc1,
> alsaplayer makes intermitted random noise.
> Bisecting worked fine and the last steps were:
> 
> $ git bisect good
> Bisecting: 9 revisions left to test after this
> [71848d687e2a477cb7c68a854d8fdeaa5dff0ffc] x86: remove virt_to_bus in pci-dma_64.c
> 
> $ git bisect good
> Bisecting: 4 revisions left to test after this
> [8f19ca1341a6d89bd96e2e69e6e10f46d3258089] x86: unify gfp masks
> 
> $ git bisect bad
> Bisecting: 2 revisions left to test after this
> [45a07e774950ef479f8996c0e2c5550dd6440453] x86: use a fallback dev for i386
> 
> $ git bisect good
> Bisecting: 1 revisions left to test after this
> [5fa78ca75d8e67063948a01b51594a0904af5710] x86: retry allocation if failed
> 
> The last kernel is bad.
> Checked 2.6.26-rc2 too which is bad.
> 
> This is a 10+x year old laptop, but it does useful work for me.
> The driver is snd_sb8.
> 
> Wolfgang
This is probably the same issue we had at http://lkml.org/lkml/2008/5/8/522

Can you please confirm we're talking about the same issue, i.e. , if the 
posted fix also fix your issue?

thanks.
