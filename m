Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZFWR60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZFWR60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZFWR6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:58:20 -0400
Received: from mx.treblig.org ([80.68.94.177]:34551 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZFWR6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:58:20 -0400
Date: Tue, 23 Jun 2009 19:58:15 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090623185814.GB24108@gallifrey>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz> <20090617193442.GA31944@gallifrey> <alpine.LNX.2.00.0906180126260.7457@wotan.suse.de> <20090620120357.GA11272@gallifrey> <20090622194605.GA25820@gallifrey> <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 19:46:10 up 28 days, 12:07,  1 user,  load average: 0.00, 0.01, 0.05
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina (jkosina@suse.cz) wrote:
> On Mon, 22 Jun 2009, Dr. David Alan Gilbert wrote:
> 
> > > Yes, with i8042.noaux it works; dmesg snippet included below.
> > > And in reply to hpa, it doesn't have a mouse port.
> > I saw you also asked for a dmidecode -t system dmidecode says the 
> > machine has 'No SMBIOS nor DMI entry point'.
> 
> Hmm, that means that there is no easy way to identify your particular 
> machine (which apparently has somewhat broken AUX i8042 port) in run-time 
> for quirk to be applied. I am afraid you'll need to live with specifying 
> the command-line kernel parameter on this machine.

Yep; I'm OK with the i8042.noaux from my point of view, but it's a
bit worrying that this used to work fine.  There's obviously been
a change somewhere since 2.6.18 (and as I remember from the dmesg
the keyboard and aux ports are being initialised in different orders).
(Actually I say obviously since 2.6.18 - but the 2.6.18 I tried
I think I only used the debian version - I should go back and
see if I can do a vanilla one), but this box has been running
Linux since the time it was originally bought with loads of distros
and clean kernels years ago.

While this machine is old, the motherboard was a pretty common one
at the time.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
