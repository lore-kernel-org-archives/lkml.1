Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYFRTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYFRTFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYFRTFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:05:46 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:56302 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYFRTFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:05:45 -0400
Date: Wed, 18 Jun 2008 21:05:44 +0200
Message-Id: <322174127@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anthony Liguori <anthony@codemonkey.ws>, ecollins@vmware.com,
       Javier Guerra <javier@guerrag.com>, Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+D0CWz43j6TBXf4clWjiZS0xl4Y/PSjjbUMsQmKEBrci3Xe
 XZKQ5EDzPjh5QcpvBxoucGqTaRigv/9hKcZIQW3n+X+A7DhZa4=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i`d like to give a comment about those claims in this thread (see below),  vmware kernel part would be closed source or binary module.

i think, they aren´t. they just are not available via public/opensource code repository.

just go and download workstation 6.5 beta from:

http://download3.vmware.com/software/wkst/VMware-workstation-e.x.p-91182.i386.tar.gz
(you may need register for that)

unpack and take a look at vmware-distrib/lib/modules/source - there is source for 6 independent kernel
modules in those .tar files:

vmblock, vmci, vmmon, vmnet, vmppuser and vsock. (~3MB alltogether)

regards
roland


------------------------------------------------------------------------------------

>i think what he's saying is that VMWare is a closed binary blob
>executing in the kernel; so there's no way to certify anything with
>this.

>as soon as you put some unknown (and unknowable, unverifiable,
>untrustable) code in the kernel, you can't know what will work and
>what won't.

------------------------------------------------------------------------------------

>So ask vmware. They have source to both parts we don't."

------------------------------------------------------------------------------------

>If the VMware code was upstream, then we could work together to make a 
>software arbitration mechanism.  It's not, and worse yet, it's closed 
>source so there's no chance it will be.  Even if someone wrote an 
>arbitration mechanism and got VMware to use it, it still shouldn't be 
>merged because KVM would be the only thing using that mechanism 
>upstream.  I'm not interested in adding kernel infrastructure to support 
>external binary kernel modules.

------------------------------------------------------------------------------------

>VMware is a binary kernel module that's out of kernel.  KVM is not 
>misbehaving and the fact that VMware breaks when the KVM module is 
>loaded isn't our problem.  If they submitted their code for inclusion in 
>mainline, we could possibly come up with solution for arbitrating who is 
>using VT.

------------------------------------------------------------------------------------


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

