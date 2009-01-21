Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbZAULGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbZAULGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZAULGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:06:06 -0500
Received: from ns2.tasking.nl ([195.193.207.10]:16140 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbZAULGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:06:05 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 06:06:04 EST
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <567e52cd0901201139s1bd4e585o4a3af400c213d237@mail.gmail.com>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: plz help fixing lirc_igorplugusb kernel module
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <87c.4976ffbf.5f61c@altium.nl>
Date: Wed, 21 Jan 2009 10:58:07 -0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alex <gsmdib@gmail.com> wrote:
| Jan 20 19:11:42 s lirc_igorplugusb[3]: Device buffer overrun.
| Jan 20 19:11:48 s lirc_igorplugusb[3]: Device buffer overrun.
| Jan 20 19:11:49 s lirc_igorplugusb[3]: Device buffer overrun.
| --
| The problem naturally lies in the last third lines which reflect the
| way kernel module reacts to key presses on remote. The very same
| device works flawlessly under Win + Girder.
| I'd be very thankful if someone could help me fixing the issue (or
| rather if I could help fixing this issue).

This error is caused by an IR code longer than 36 pulse/space periods.
Perhaps the Windows driver simply ignores this condition? Did you try
to remove the code that handles this case and where this message is
issued?

<plug>
You can also try my USBtiny implementation, which also works with this
driver. It limits the number of periods to 35 by wrapping the last 16
periods: http://www.xs4all.nl/~dicks/avr/usbtiny/
</plug>

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

