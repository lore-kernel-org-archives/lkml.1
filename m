Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYGSR62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYGSR62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYGSR6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:58:20 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:45093 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754995AbYGSR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:58:19 -0400
Date: Sat, 19 Jul 2008 13:58:18 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macbook2,2 latest git mmconfig issues
Message-ID: <20080719175818.GA19250@bromo.msbb.uc.edu>
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com> <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com> <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com> <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com> <20080719131038.GA13168@bromo.msbb.uc.edu> <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com> <20080719151453.GA13792@bromo.msbb.uc.edu> <dd18b0c30807190854w17059d63g10e1e199f855988b@mail.gmail.com> <20080719162856.GA14334@bromo.msbb.uc.edu> <dd18b0c30807191015i378c0f4euec76757ee285ed70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30807191015i378c0f4euec76757ee285ed70@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 10:15:52AM -0700, Justin Mattock wrote:
> 
> when using the boot options
> debug initctl_debug vga=790
> I'm able to see the hardisk is being mounted alsa
> is activated netfiler is being activated, but then
> just stops giving me the:
> VFS cannot mount on root filesystem error
> keep in mind this is when using "any" option
> in PCI, when using MMCONFIG
> im getting what you where getting
> I'm just confused on how the system was working
> without any errors with "Direct" in pci
> and now none of the options are working.
> The posotive side is better work this issue now,
> rather than later. what I'll try is loading a fresh install
> of nubuntu, and then compile the kernel with there .config
> to see if I'm able to start. Also they added apparmor so I'm not sure if
> this is causing problems as well.
> -- 
> Justin P. Mattock

Justin,
   Just to be clear, you do have CONFIG_PCIEASPM unset in your .config,
right? All 2.6.26 kernels I have tried (including tip) hang during the
boot when built with that option.
                Jack
