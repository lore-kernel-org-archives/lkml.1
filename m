Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbZDGSNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbZDGSNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbZDGSNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:13:41 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:58917 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbZDGSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:13:39 -0400
Subject: Re: [Announce] 2.6.29.1-rt4
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0904071854480.21577@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <1238799852.3871.6.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904040628310.12916@localhost.localdomain>
	 <1238828273.15225.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904051552320.747@localhost.localdomain>
	 <1238968196.4995.15.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904060001480.747@localhost.localdomain>
	 <1238973052.4995.29.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904062151020.21577@localhost.localdomain>
	 <1239123123.12637.9.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904071854480.21577@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-yQ4SLWKPh6as43dfcjXC"
Date: Tue, 07 Apr 2009 11:13:07 -0700
Message-Id: <1239127987.3432.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yQ4SLWKPh6as43dfcjXC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-04-07 at 18:58 +0200, Thomas Gleixner wrote:
> Fernando,
> 
> On Tue, 7 Apr 2009, Fernando Lopez-Lezcano wrote:
> 
> > On Mon, 2009-04-06 at 21:54 +0200, Thomas Gleixner wrote:
> > > Fernando,
> > > 
> > > On Sun, 5 Apr 2009, Fernando Lopez-Lezcano wrote:
> > > > > Hmm. Can you upload your full patch queue and the binary rpm so I can
> > > > > give it a test ride ?
> > > > 
> > > > Sure, no problem. I just did a release to planetcore-testing repo (with
> > > > a warning to the planetccrma list), you can find it here:
> > > > 
> > > > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/i386/repoview/index.html
> > > > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/x86_64/repoview/index.html
> > > > 
> > > > (the one I have tested and hangs is the i386 PAE version)
> > > > Source here:
> > > > 
> > > > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/SRPMS/
> > > > 
> > > > (if you don't want to figure out the .src.rpm - I would not blame you -
> > > > I can give you a list of the patches that were actually applied - of the
> > > > ones that are included in the package)
> > > 
> > > No problem. I know how to distangle those beasts.
> > > 
> > > Still I have no reproducer yet. One of my 32bit test machines survived
> > > a 200 cycle test w/o showing it.
> > 
> > Arghh, I don't know what it could be then. You mean 200 power cycles??
> > Wow... it only takes one here. Thanks for testing. 
> 
> Does it trigger when you just boot up and the immediately shut down
> w/o doing any work on it ?

Yes. Just tried again. Clarification: triggers on a "halt -p", _not_ on
a reboot. 

> Could you try whether the following triggers the bug as well: Boot up,
> do work or whatever. Make sure your data is sycned to disk. :)
> 
> # echo 0 >/sys/devices/system/cpu/cpu1/online
> 
> If that does not trigger, then check whether it survives the
> shutdown/reboot. If it does we look further.

It triggers it immediately (in my laptop), I tried from a text console
and it spews things and at the bottom a poke_text thing like before
(after a while I got a couple of messages from iwl3945 about a timeout
and somehow it started to reboot, either when I pressed the power button
or when I did <ctrl><alt><del>)

> > > Is there anything special what you run, load ... ?
> > 
> > Not that I can think of right now. This happens on 32 bit installs on
> > both Fedora 9 and Fedora 10. Nothing special installed, of course I have
> > the Planet CCRMA packages but they don't involve additional kernel
> > modules or anything that (I think) deals with startup or shutdown. 
> 
> Can you provide the list of modules loaded ?

Three lists attached, first all modules after I login, then modules
after a single user boot and then two more after I removed bluetooth and
80211* modules on a hunch, fails to power off in all cases (I first saw
a ref to blue something at the very top of the dump, so removed that,
then saw a reference to 80211 at the top, removed that, then I gave
up :-) 

-- Fernando


--=-yQ4SLWKPh6as43dfcjXC
Content-Disposition: attachment; filename="lsmod.multi"
Content-Type: text/plain; name="lsmod.multi"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Module                  Size  Used by
fuse                   47992  2 
i915                  131684  2 
drm                   122684  3 i915
i2c_algo_bit            4676  1 i915
rfcomm                 30904  4 
bridge                 40532  0 
stp                     1884  1 bridge
bnep                   10788  2 
sco                     8924  2 
l2cap                  17584  16 rfcomm,bnep
sunrpc                152904  1 
ip6t_REJECT             3148  2 
nf_conntrack_ipv6      11064  2 
ip6table_filter         2164  1 
ip6_tables             10632  1 ip6table_filter
ipv6                  235136  22 ip6t_REJECT,nf_conntrack_ipv6
cpufreq_ondemand        5916  2 
acpi_cpufreq            8304  0 
dm_multipath           13836  0 
uinput                  6748  0 
snd_hda_codec_analog    54824  1 
snd_hda_intel          23716  3 
snd_hda_codec          53840  2 snd_hda_codec_analog,snd_hda_intel
snd_hwdep               6584  1 snd_hda_codec
snd_seq_dummy           2456  0 
arc4                    1532  2 
snd_seq_oss            27444  0 
snd_seq_midi_event      5596  1 snd_seq_oss
snd_seq                45620  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          5980  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            38504  0 
thinkpad_acpi          52544  0 
hwmon                   2160  1 thinkpad_acpi
snd_mixer_oss          14360  1 snd_pcm_oss
snd_pcm                62088  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
sdhci_pci               6484  0 
sdhci                  14428  1 sdhci_pci
ecb                     2348  2 
pcspkr                  2080  0 
i2c_i801                8176  0 
i2c_core               17828  4 i915,drm,i2c_algo_bit,i2c_i801
iTCO_wdt               10284  0 
yenta_socket           21404  1 
mmc_core               40752  1 sdhci
iwl3945               123748  0 
rfkill                  8668  4 thinkpad_acpi,iwl3945
mac80211              167760  1 iwl3945
iTCO_vendor_support     2660  1 iTCO_wdt
rsrc_nonstatic         10192  1 yenta_socket
snd_timer              17924  2 snd_seq,snd_pcm
ohci1394               26208  0 
lib80211                4992  1 iwl3945
joydev                  9080  0 
snd                    50516  18 snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
cfg80211               31272  2 iwl3945,mac80211
soundcore               5476  1 snd
snd_page_alloc          7652  2 snd_hda_intel,snd_pcm
ricoh_mmc               3360  0 
btusb                  10716  3 
bluetooth              45472  11 rfcomm,bnep,sco,l2cap,btusb
video                  17132  0 
output                  2436  1 video
e1000e                100600  0 
ata_generic             4240  0 
pata_acpi               3524  0 

--=-yQ4SLWKPh6as43dfcjXC
Content-Disposition: attachment; filename="lsmod.single"
Content-Type: text/plain; name="lsmod.single"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Module                  Size  Used by
dm_multipath           13836  0 
uinput                  6748  0 
snd_hda_codec_analog    54824  1 
snd_hda_intel          23716  0 
snd_hda_codec          53840  2 snd_hda_codec_analog,snd_hda_intel
snd_hwdep               6584  1 snd_hda_codec
arc4                    1532  2 
snd_seq_dummy           2456  0 
snd_seq_oss            27444  0 
snd_seq_midi_event      5596  1 snd_seq_oss
snd_seq                45620  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
ecb                     2348  2 
snd_seq_device          5980  3 snd_seq_dummy,snd_seq_oss,snd_seq
iwl3945               123748  0 
thinkpad_acpi          52544  0 
snd_pcm_oss            38504  0 
snd_mixer_oss          14360  1 snd_pcm_oss
snd_pcm                62088  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
sdhci_pci               6484  0 
i2c_i801                8176  0 
hwmon                   2160  1 thinkpad_acpi
rfkill                  8668  4 iwl3945,thinkpad_acpi
yenta_socket           21404  1 
sdhci                  14428  1 sdhci_pci
ohci1394               26208  0 
rsrc_nonstatic         10192  1 yenta_socket
ricoh_mmc               3360  0 
mmc_core               40752  1 sdhci
pcspkr                  2080  0 
i2c_core               17828  1 i2c_i801
mac80211              167760  1 iwl3945
video                  17132  0 
snd_timer              17924  2 snd_seq,snd_pcm
iTCO_wdt               10284  0 
joydev                  9080  0 
snd                    50516  12 snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
btusb                  10716  0 
iTCO_vendor_support     2660  1 iTCO_wdt
e1000e                100600  0 
soundcore               5476  1 snd
lib80211                4992  1 iwl3945
output                  2436  1 video
snd_page_alloc          7652  2 snd_hda_intel,snd_pcm
cfg80211               31272  2 iwl3945,mac80211
bluetooth              45472  1 btusb
ata_generic             4240  0 
pata_acpi               3524  0 

--=-yQ4SLWKPh6as43dfcjXC
Content-Disposition: attachment; filename="lsmod.single.noblue"
Content-Type: text/plain; name="lsmod.single.noblue"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Module                  Size  Used by
dm_multipath           13836  0 
uinput                  6748  0 
snd_hda_codec_analog    54824  1 
snd_hda_intel          23716  0 
snd_hda_codec          53840  2 snd_hda_codec_analog,snd_hda_intel
snd_hwdep               6584  1 snd_hda_codec
snd_seq_dummy           2456  0 
snd_seq_oss            27444  0 
arc4                    1532  2 
snd_seq_midi_event      5596  1 snd_seq_oss
ecb                     2348  2 
snd_seq                45620  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          5980  3 snd_seq_dummy,snd_seq_oss,snd_seq
thinkpad_acpi          52544  0 
iwl3945               123748  0 
snd_pcm_oss            38504  0 
hwmon                   2160  1 thinkpad_acpi
sdhci_pci               6484  0 
snd_mixer_oss          14360  1 snd_pcm_oss
i2c_i801                8176  0 
sdhci                  14428  1 sdhci_pci
ohci1394               26208  0 
rfkill                  8668  4 thinkpad_acpi,iwl3945
yenta_socket           21404  1 
mmc_core               40752  1 sdhci
snd_pcm                62088  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
rsrc_nonstatic         10192  1 yenta_socket
pcspkr                  2080  0 
ricoh_mmc               3360  0 
i2c_core               17828  1 i2c_i801
mac80211              167760  1 iwl3945
iTCO_wdt               10284  0 
joydev                  9080  0 
video                  17132  0 
snd_timer              17924  2 snd_seq,snd_pcm
iTCO_vendor_support     2660  1 iTCO_wdt
snd                    50516  12 snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
e1000e                100600  0 
lib80211                4992  1 iwl3945
soundcore               5476  1 snd
cfg80211               31272  2 iwl3945,mac80211
output                  2436  1 video
snd_page_alloc          7652  2 snd_hda_intel,snd_pcm
ata_generic             4240  0 
pata_acpi               3524  0 

--=-yQ4SLWKPh6as43dfcjXC
Content-Disposition: attachment; filename="lsmod.single.no80211"
Content-Type: text/plain; name="lsmod.single.no80211"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Module                  Size  Used by
dm_multipath           13836  0 
uinput                  6748  0 
snd_hda_codec_analog    54824  1 
snd_hda_intel          23716  0 
snd_hda_codec          53840  2 snd_hda_codec_analog,snd_hda_intel
snd_hwdep               6584  1 snd_hda_codec
arc4                    1532  0 
snd_seq_dummy           2456  0 
snd_seq_oss            27444  0 
ecb                     2348  0 
snd_seq_midi_event      5596  1 snd_seq_oss
snd_seq                45620  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          5980  3 snd_seq_dummy,snd_seq_oss,snd_seq
thinkpad_acpi          52544  0 
snd_pcm_oss            38504  0 
rfkill                  8668  2 thinkpad_acpi
hwmon                   2160  1 thinkpad_acpi
snd_mixer_oss          14360  1 snd_pcm_oss
pcspkr                  2080  0 
sdhci_pci               6484  0 
i2c_i801                8176  0 
sdhci                  14428  1 sdhci_pci
snd_pcm                62088  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
yenta_socket           21404  1 
ohci1394               26208  0 
mmc_core               40752  1 sdhci
joydev                  9080  0 
rsrc_nonstatic         10192  1 yenta_socket
i2c_core               17828  1 i2c_i801
ricoh_mmc               3360  0 
iTCO_wdt               10284  0 
snd_timer              17924  2 snd_seq,snd_pcm
video                  17132  0 
snd                    50516  12 snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
iTCO_vendor_support     2660  1 iTCO_wdt
e1000e                100600  0 
output                  2436  1 video
soundcore               5476  1 snd
snd_page_alloc          7652  2 snd_hda_intel,snd_pcm
ata_generic             4240  0 
pata_acpi               3524  0 

--=-yQ4SLWKPh6as43dfcjXC--

