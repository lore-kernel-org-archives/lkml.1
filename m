Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbYDBACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbYDBACw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbYDBACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:02:44 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:35722 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756809AbYDBACn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:02:43 -0400
Message-ID: <47F2CD1B.7060804@davidnewall.com>
Date: Wed, 02 Apr 2008 10:32:35 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com> <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr> <47EDE2A4.8080702@davidnewall.com> <47EE76BD.2000708@zytor.com> <alpine.LNX.1.10.0804012200340.6604@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0804012200340.6604@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hence the proposal of using definite start and end markers:
>
>     echo -e '\x1B43m\x1D wonderful \x1B0m\x1D' | cosmicrays | cat

I see no merit in the idea.  Most seriously, there isn't any real-world
problem being solved.  In addition, it proposes creating yet another
type of terminal emulation.  If there's something you don't like about
VT escape codes, use a different emulation.  For example, Televideo
terminals used almost exclusively single-character control codes,
reducing the scope of being mid-sequence to, well much closer to zero.

You need to make quite clear that your proposal is to discontinue use of
VT terminal emulation.
