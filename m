Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZGZSPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZGZSPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 14:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZGZSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 14:15:09 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:49945 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbZGZSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 14:15:08 -0400
Message-ID: <4A6C9D1F.3090404@blueyonder.co.uk>
Date: Sun, 26 Jul 2009 19:14:55 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-1.1 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, Sid Boyce <sboyce@blueyonder.co.uk>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: OpenSolaris boot failure with KVM and VirtualBox
References: <4A5ED714.7010304@blueyonder.co.uk> <4A6C80C3.8090007@redhat.com>
In-Reply-To: <4A6C80C3.8090007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/09 17:13, Avi Kivity wrote:
> On 07/16/2009 10:30 AM, Sid Boyce wrote:
>> I first tried using kernel 2.6.31-rc1 on openSUSE 11.2 Milestone1 on a
>> 4P box. All other VM's, Windows and Linux work, currently running
>> openSUSE 11.2 Milestone 3 with 2.6.31-rc3. Verified the .iso is good.
>> Error message
>> =============
>> Booting 'OpenSolaris 2009.06'
>> kernel$ /platform/i86pc/kernel/$ISADIR/unix
>> loading '/platform/i86pc/kernel/$ISADIR/unix' ...
>> cpu: 'AuthenticAMD' family 16 model 4 step 2 ...
>> [BIOS accepted mixed-mode target setting!]
>>    [Multiboot-kernel, loadaddr=0xbffe38, text-and-data=0x1b1ff0, bss=0x0,
>> entry=0xc00000]
>> 'platform/i86pc/kernel/amd64/unix' is loaded
>> module$ /boot/$ISADIR/x86.microroot
>> loading '/boot/$ISADIR/x86.microroot' ...
>> Error 15: File not found
>> Press any key to continue ...
>> Regards
>> Sid.
>>    
> 
> Please copy kvm@vger.kernel.org on kvm issues.
> 
> Is this a regression from previous kernel versions?  What userspace are
> you using?
> 

Currently running 2.6.31-rc4 with the original kqemu-1.4.0pre1 on
openSUSE 11.2 Milestone 4 and it boots OK - a 200G disk image used.
qemu-system-x86_64 -cdrom /ISO/osol-0906-ai-x86.iso -boot d
/osol0906.qcow2 -smp 4 -m 500M &
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

