Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZKCVao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZKCVao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZKCVan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:30:43 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:48521 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbZKCVam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:30:42 -0500
X-Greylist: delayed 1084 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 16:30:42 EST
Date: Tue, 3 Nov 2009 22:12:34 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Nikola Ciprich <extmaillist@linuxbox.cz>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: 2.6.31.4 panic: CRED: put_cred_rcu() sees ffff880204e58c00
	with usage 82150912
Message-ID: <20091103211234.GB4676@nik-comp.linuxbox.cz>
References: <20091030110632.GC6416@develbox.linuxbox.cz> <20091030111534.GD6416@develbox.linuxbox.cz> <20091103144638.GE10084@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20091103144638.GE10084@amt.cnet>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 2886966 records(03-11-2009)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Marcelo,
well, my report might have been a bit misleading, 2.6.31.2 has been running=
 there for almost 3 weeks.
So the problem didn't occur JUST after the upgrade. But it never occured be=
fore it, while
we were using older kernels (varius 2.6.30.x, 2.6.29.x and older).
I've updated machine to 2.6.31.5, and it's been running without problem sin=
ce then,
but it's been just few days, so we'll see.
I'll report if the problem appears again.
Thanks.
regards
nik

On Tue, Nov 03, 2009 at 12:46:38PM -0200, Marcelo Tosatti wrote:
> On Fri, Oct 30, 2009 at 12:15:34PM +0100, Nikola Ciprich wrote:
> > Ouch, typo in subject, it's 2.6.31.1 of course. sorry about that.
> > also CCing kvm.
> > n.
> >=20
> > On Fri, Oct 30, 2009 at 12:06:32PM +0100, Nikola Ciprich wrote:
> > > Hi,
> > > some time ago, I updated my KVM hosting machine to 2.6.31.1 and it ju=
st died horribly:
>=20
> Nikola,
>=20
> Upgraded from what? Did you see experience the crash again?
>=20
> > > Oct 30 10:45:17 vbox [706369.133516] Kernel panic - not syncing: CRED=
: put_cred_rcu() sees ffff880204e58c00 with usage 82150912
> > > Oct 30 10:45:17 vbox [706369.133519]
> > > Oct 30 10:45:17 vbox [706369.144990] Pid: 19, comm: ksoftirqd/5 Not t=
ainted 2.6.31lb.02 #1
> > > Oct 30 10:45:17 vbox [706369.151554] Call Trace:
> > > Oct 30 10:45:17 vbox [706369.154332]  <IRQ>
> > > Oct 30 10:45:17 vbox [<ffffffff8104c1fa>] panic+0xaa/0x180
> > > Oct 30 10:45:17 vbox [706369.160280]  [<ffffffff81322b90>] ? _spin_un=
lock+0x30/0x60
> > > Oct 30 10:45:17 vbox [706369.166256]  [<ffffffff810f5671>] ? add_part=
ial+0x21/0x90
> > > Oct 30 10:45:17 vbox [706369.172155]  [<ffffffff810f6a92>] ? __slab_f=
ree+0x92/0x3c0
> > > Oct 30 10:45:17 vbox [706369.178127]  [<ffffffff81102317>] ? file_fre=
e_rcu+0x37/0x50
> > > Oct 30 10:45:17 vbox [706369.184198]  [<ffffffff8106c655>] put_cred_r=
cu+0x75/0x80
> > > Oct 30 10:45:17 vbox [706369.190008]  [<ffffffff810a2525>] __rcu_proc=
ess_callbacks+0x125/0x250
> > > Oct 30 10:45:17 vbox [706369.197020]  [<ffffffff810a2689>] rcu_proces=
s_callbacks+0x39/0x60
> > > Oct 30 10:45:17 vbox [706369.203624]  [<ffffffff81052a61>] __do_softi=
rq+0xc1/0x250
> > > Oct 30 10:45:17 vbox [706369.209506]  [<ffffffff81053860>] ? ksoftirq=
d+0x0/0x1a0
> > > Oct 30 10:45:17 vbox [706369.215182]  [<ffffffff8100c4dc>] call_softi=
rq+0x1c/0x30
> > > Oct 30 10:45:17 vbox [706369.220986]  [<ffffffff8100e46d>] do_softirq=
+0x3d/0x80
> > > Oct 30 10:45:17 vbox [706369.227317]  [<ffffffff81053860>] ? ksoftirq=
d+0x0/0x1a0
> > > Oct 30 10:45:17 vbox [706369.233020]  [<ffffffff810538e4>] ksoftirqd+=
0x84/0x1a0
> > > Oct 30 10:45:17 vbox [706369.238622]  [<ffffffff81066686>] kthread+0x=
a6/0xb0
> > > Oct 30 10:45:17 vbox [706369.243956]  [<ffffffff8100c3da>] child_rip+=
0xa/0x20
> > > Oct 30 10:45:17 vbox [706369.249390]  [<ffffffff810665e0>] ? kthread+=
0x0/0xb0
> > > Oct 30 10:45:17 vbox [706369.254806]  [<ffffffff8100c3d0>] ? child_ri=
p+0x0/0x20
> > > Oct 30 10:45:17 vbox [706369.260454] Rebooting in 10 seconds..
> > > (trace is obtained from netconsole, so hopefully it's not mangled).
> > > The machine was running ~30 KVM guests, it's 8CPU 16GB x86_64, when i=
t crashed, it was only
> > > moderately loaded. Never had this (or any other) kind of crash on it =
before.
> > > I know there's 2.6.31.5 already out, but I'm not sure if some related=
 problem has been
> > > reported/fixed and I'm obviously not able to quicky test/reproduce it=
 with latest kernel,
> > > so I'm rather reporting.
> > > Should more information/testing/etc be required, I'll be glad to help
> > > regards
> > > nik
>=20

--=20
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFK8JzC3xdJJrLygV4RAtQ5AJsFVcWroZK1d/33doaMqKNLwWPnfQCgxin2
VWRvrMO1DQnx7pO0Blcg9Io=
=NlF5
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
