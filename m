Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZAVOhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZAVOhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZAVOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:36:58 -0500
Received: from ns2.tasking.nl ([195.193.207.10]:47482 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZAVOg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:36:57 -0500
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <87c.4976ffbf.5f61c@altium.nl> <567e52cd0901201139s1bd4e585o4a3af400c213d237@mail.gmail.com> <87c.4976ffbf.5f61c@altium.nl> <21605162.post@talk.nabble.com>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: plz help fixing lirc_igorplugusb kernel module
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <4237.49788488.6c688@altium.nl>
Date: Thu, 22 Jan 2009 14:36:56 -0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gsmd <gsmdib@gmail.com> wrote:
| Here's the section from lirc_igorplugusb.c
| (ftp.gnu.org/tmp/linux-libre-fsf2_2.6.28/linux-2.6.28/ubuntu/lirc/lirc_igorplugusb/lirc_igorplugusb.c)
| that displays the message:
| --
| 		if (ir->buf_in[2] != 0) {
| 			printk(DRIVER_NAME "[%d]: Device buffer overrun.\n",
| 				ir->devnum);
| 			/* start at earliest byte */
| 			i = DEVICE_HEADERLEN + ir->buf_in[2];
| 			/* where are we now? space, gap or pulse? */
| 		}
| --
| With my limited C knowledge I don't see what would prevent displaying the
| key code (when I run irw) after the message. Haven't tried removing it
| though.

The variable 'i' is modified, which affects the amount of data that is
returned to LIRC. I suggest removing at least this line, to see if
that helps.

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

