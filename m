Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZASXO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZASXO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZASXOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:14:47 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:63054 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZASXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:14:46 -0500
Message-ID: <49750964.5060000@cfl.rr.com>
Date: Mon, 19 Jan 2009 18:14:44 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: markh@compro.net
CC: Borislav Petkov <borislav.petkov@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <497322CC.7050900@cfl.rr.com> <20090119142259.GA22012@aftab> <4974940B.6070407@compro.net>
In-Reply-To: <4974940B.6070407@compro.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Borislav Petkov wrote:
>> Hi,
>>
>> On Sun, Jan 18, 2009 at 07:38:36AM -0500, Mark Hounschell wrote:
>>> I upgraded from a Phenom to a Phenom-II processor and I could no longer boot.
>>>
>>> I have tried kernels from 2.6.26 through 2.6.28.
>>>
>>> I _can_ however boot these kernels when they are configured for HZ = 250. I
>>> haven't tried HZ = 300. But certainly if HZ = 1000 the boot hangs at the spot
>>> indicated below in the dmesg output.
>>>
>>> The machine is up and stable running 2.6.26.8 with a (HZ = 1000) configured kernel.
>>>
>>> While running a 2.6.26.8 kernel configured for HZ = 250:
>>>
>>> /proc/version:
>>>
>>> Linux version 2.6.26.8 (root@harley) (gcc version 4.3.1 20080507 (prerelease)
>>> [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Sat Jan 17
>>> 16:37:58 EST 2009
>>>
>>>
>>> scripts/ver_linux:
>>>
>>> If some fields are empty or look unusual you may have an old version.
>>> Compare to the current minimal requirements in Documentation/Changes.
>>>
>>> Linux harley 2.6.26.8 #2 SMP PREEMPT Sat Jan 17 16:37:58 EST 2009 i686 athlon
>>> i386 GNU/Linux
>>>
>>> Gnu C                  4.3
>>> Gnu make               3.81
>>> binutils               11.0
>>> 2.18.50.20080409
>>> 11.1
>>> util-linux             2.13.1
>>> mount                  2.13.1
>>> module-init-tools      3.4
>>> e2fsprogs              1.40.8
>>> reiserfsprogs          3.6.19
>>> PPP                    2.4.4
>>> Linux C Library        2.8
>>> Dynamic linker (ldd)   2.8
>>> Procps                 3.2.7
>>> Net-tools              1.60
>>> Kbd                    1.12
>>> Sh-utils               6.11
>>> udev                   120
>>> wireless-tools         29
>>> Modules Loaded         ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit
>>> snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device appletalk ax25 ipx p8023
>>> ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT xt_state iptable_mangle iptable_nat
>>> nf_nat iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4
>>> nf_conntrack ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod
>>> snd_hda_intel snd_pcm snd_timer ati_agp nvidia snd ppdev rtc_cmos ide_cd_mod
>>> i2c_piix4 parport_pc rtc_core usb_storage usblp soundcore cdrom agpgart
>>> snd_page_alloc parport rtc_lib e1000e ide_disk i2c_core sg ehci_hcd ohci_hcd
>>> sd_mod usbcore ssb e1000 sky2 edd ext3 mbcache jbd aic7xxx scsi_transport_spi
>>> atiixp ide_core ahci pata_jmicron libata scsi_mod dock
>>>
>>>
>>> /proc/cpuinfo:
>>>
>>> processor       : 0
>>> vendor_id       : AuthenticAMD
>>> cpu family      : 16
>>> model           : 4
>>> model name      : AMD Processor model unknown
>> judging from the processor name string it looks like your BIOS doesn't
>> program the processor name properly which could mean that you need
>> to check whether your motherboard supports Phenom II CPUs and if so,
>> upgrade your BIOS. This could also explain the mis-calibration issue.
>>
>> Also, is this a 32-bit kernel you're booting?
>>
> 
> Yes, I am running 32 bit kernels. Also as I stated in my original post the MB
> does report "AMD Processor model unknown" at post. I assume a BIOS update
> will be forth coming. Actually when the Phonom-I was installed it was an upgrade
> (well it turned out to be a downgrade) from an AMD X2 6400+. The BIOS at that
> time reported the same thing until there was a BIOS update for it. Also FWIW,
> at that time I was able to boot a HZ=1000 kernel. Don't remember looking at the
> lpj values though.
> 

I'm waiting for a response from the MFGR, but I doubt I will actually hear from
them. Like I said above, the Phenom-I worked (or at least seemed to) before they
provided a BIOS update for it.

Somehow I don't think "the boot issue" is a mis-calibration issue. As it boots
now with a 250Hz kernel, it is still mis-calibrated for cpu0, but still boots.

Initializing CPU#0
Calibrating delay loop... 3956.73 BogoMIPS (lpj=7913472)

Initializing CPU#1
Calibrating delay using timer specific routine.. 6000.60 BogoMIPS (lpj=12001200)

Initializing CPU#2
Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000950)

Initializing CPU#3
Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000955)


Regards
Mark

