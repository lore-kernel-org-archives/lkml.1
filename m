Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZBPVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZBPVgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZBPVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:36:12 -0500
Received: from main.gmane.org ([80.91.229.2]:40460 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbZBPVgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:36:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: &&//|| typo ?
Date: Mon, 16 Feb 2009 22:35:54 +0100
Message-ID: <gncm7q$gp8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5088fc62.dip.t-dialin.net
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

inspired by the mail http://lkml.org/lkml/2009/2/15/159
I did

grep -Ern '\!=.*\|\|.*\!=' linux-2.6.28.5

and found the following tests which are always true if the tested variable is
not NaN:

linux-2.6.28.5/sound/pci/au88x0/au88x0_core.c:2792:	if ((bits != 8) || (bits != 16))

linux-2.6.28.5/sound/oss/ad1848.c:283:		if ( (devc->model != MD_1845) ||
(devc->model != MD_1845_SSCAPE))
linux-2.6.28.5/sound/oss/ad1848.c:2110:			if (devc->model != MD_1845 ||
devc->model != MD_1845_SSCAPE)

linux-2.6.28.5/arch/x86/kvm/vmx.c:1794:	if ((ss.type != 3) || (ss.type != 7))
linux-2.6.28.5/arch/x86/kvm/vmx.c:1837:	if ((tr.type != 3) || (tr.type != 11))
/* TODO: Check if guest is in IA32e mode */

linux-2.6.28.5/net/sunrpc/auth_unix.c:122:	if (cred->uc_uid != acred->uid ||
cred->uc_gid != acred->gid)

linux-2.6.28.5/net/sunrpc/svcauth_unix.c:747:	if (svc_getu32(argv) !=
htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
linux-2.6.28.5/net/sunrpc/svcauth_unix.c:833:	if (svc_getu32(argv) !=
htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {

linux-2.6.28.5/net/sunrpc/auth_gss/gss_krb5_seqnum.c:78:	if ((plain[4] !=
plain[5]) || (plain[4] != plain[6])
linux-2.6.28.5/net/sunrpc/auth_gss/gss_krb5_seqnum.c:79:				   || (plain[4] !=
plain[7]))

linux-2.6.28.5/drivers/block/paride/pf.c:569:		if ((buf[k + offs] != 0x20) ||
(buf[k + offs] != l))

already known:

linux-2.6.28.5/drivers/block/paride/pg.c:425:		if (c != ' ' || c != l)

linux-2.6.28.5/drivers/block/paride/pt.c:506:		if ((buf[k + offs] != 0x20) ||
(buf[k + offs] != l))

linux-2.6.28.5/drivers/misc/sgi-gru/grukservices.c:612:	if (word0 != word1 ||
word0 != MAGIC) {

linux-2.6.28.5/drivers/scsi/gvp11.c:283:	if (qq != q || qq != 0xff)	/* should be
read only, all 1's */

linux-2.6.28.5/drivers/scsi/FlashPoint.c:6045:				if(bit_cnt != 0 || bit_cnt != 8)

-- 
Regards,
Jörg-Volker.

