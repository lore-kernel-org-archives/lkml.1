Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZG1O4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZG1O4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZG1O4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:56:25 -0400
Received: from os.eurotux.com ([216.75.63.6]:43254 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZG1O4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:56:24 -0400
Date: Tue, 28 Jul 2009 15:56:17 +0100
From: Luciano Rocha <luciano@eurotux.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: eeepc_hotkey adds 25s to boot
Message-ID: <20090728145617.GG11494@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alan Jenkins <sourcejedi.lkml@googlemail.com>,
	linux-kernel@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <20090727192720.GA30366@bit.office.eurotux.com>
 <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
 <9b2b86520907271304i3709d1e0s1cf43c6e9f48f794@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b2b86520907271304i3709d1e0s1cf43c6e9f48f794@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-07-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:04:23PM +0100, Alan Jenkins wrote:
> On 7/27/09, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > (Adding Corentin to cc)
> >
> > On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com> wrote:
> >> As subject says, loading the eeepc_hotkeys driver or including it inside
> >> the kernel adds 25s to the boot process:
> >> [   13.990092] eeepc: Eee PC Hotkey Driver
> >> [   39.560645] eeepc: Hotkey init flags 0x41
> >> [   39.566131] eeepc: Get control methods supported: 0x101713
> >> [   39.566418] input: Asus EeePC extra buttons as ...
> >>
> >> Kernel is 2.6.30.3 (with tuxonice).
> 
> Sounds like <http://bugzilla.kernel.org/show_bug.cgi?id=13620>.  If
> I'm right, it will go away if you blacklist the i2c_i801 module.  E.g.

Thanks, compiling it out did the trick.

Oh, BTW, this was in an Eeepc 1000.

Regards,
Luciano Rocha

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
