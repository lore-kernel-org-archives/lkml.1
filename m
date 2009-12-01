Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZLAKMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZLAKMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZLAKMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:12:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbZLAKMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:12:33 -0500
Message-ID: <4B14EC12.20902@redhat.com>
Date: Tue, 01 Dec 2009 12:12:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
       kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b
 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com>	<87k4x9saqn.fsf@spindle.srvr.nix> <4B1283F5.5060204@redhat.com>	<87y6lorjq6.fsf@spindle.srvr.nix> <20091130130509.52762237@varda> <87d42zr8rl.fsf@spindle.srvr.nix> <4B14E8E9.8050305@redhat.com>
In-Reply-To: <4B14E8E9.8050305@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 11:59 AM, Avi Kivity wrote:
>
> So it looks like it is X related, and we'll have no choice other than 
> to emulate the instruction.  Annoying, since we don't emulate sse 
> instructions yet.
>

I reproduced it and confirmed - the instruction is accessing 0xa0000, 
the low memory vga window.

Is Ubuntu not testing on kvm?  It's their default hypervisor after all.


-- 
error compiling committee.c: too many arguments to function

