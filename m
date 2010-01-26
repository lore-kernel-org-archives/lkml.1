Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328Ab0AZXye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0AZXye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425Ab0AZXxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:53:55 -0500
Received: from kroah.org ([198.145.64.141]:35370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0AZXnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233928.368179161@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ron Mercer <ron.mercer@qlogic.com>,
       "David S. Miller" <davem@davemloft.net>,
       Brandon Philips <bphilips@suse.de>
Subject: [57/98] qlge: Add handler for DCBX firmware event.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Mercer <ron.mercer@qlogic.com>

commit 91ced682f9de17ebab5fcb2a70b48e372eb43281 upstream.

The driver has nothing to do, but this marker prevents the event from
showing up 'not handled'.

Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/qlge/qlge_mpi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/qlge/qlge_mpi.c
+++ b/drivers/net/qlge/qlge_mpi.c
@@ -446,6 +446,9 @@ static int ql_mpi_handler(struct ql_adap
 		ql_aen_lost(qdev, mbcp);
 		break;
 
+	case AEN_DCBX_CHG:
+		/* Need to support AEN 8110 */
+		break;
 	default:
 		QPRINTK(qdev, DRV, ERR,
 			"Unsupported AE %.08x.\n", mbcp->mbox_out[0]);


