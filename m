Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZLAJ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZLAJ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZLAJ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:59:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbZLAJ7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:59:05 -0500
Message-ID: <4B14E8E9.8050305@redhat.com>
Date: Tue, 01 Dec 2009 11:59:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
       kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b
 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com>	<87k4x9saqn.fsf@spindle.srvr.nix> <4B1283F5.5060204@redhat.com>	<87y6lorjq6.fsf@spindle.srvr.nix> <20091130130509.52762237@varda> <87d42zr8rl.fsf@spindle.srvr.nix>
In-Reply-To: <87d42zr8rl.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 11:40 PM, Nix wrote:
>
> So I started with -vga std. The emulation failed flood is unaffected
> (strangely it's not consistent: it happens about half the time). As soon
> as I issue a 'stop gdm', X exits and the emulation flood halts: but
> although there are other getties running I can't find a way to switch to
> them, as qemu has stolen Ctrl-Alt for its own purposes: so the system is
> pretty much useless (maybe I should get an sshd up and try to restart
> things from there). (I've never needed to do this before: either my
> qemus have been text mode all the time, or X with one console.)
>
> Surely switching VTs is possible: any clues?
>    

'sendkey alt-ctrl-f2' from the qemu monitor.

So it looks like it is X related, and we'll have no choice other than to 
emulate the instruction.  Annoying, since we don't emulate sse 
instructions yet.

-- 
error compiling committee.c: too many arguments to function

