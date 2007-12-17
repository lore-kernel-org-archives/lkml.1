Return-Path: <linux-kernel-owner+w=401wt.eu-S1765838AbXLQUQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765838AbXLQUQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762307AbXLQUAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:00:07 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35320 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762867AbXLQT76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:59:58 -0500
Message-ID: <4766D4E6.7000002@cs.wisc.edu>
Date: Mon, 17 Dec 2007 13:58:30 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Andrew Vasquez <linux-driver@qlogic.com>,
       Brian King <brking@us.ibm.com>, Dave Jeffery <ipslinux@adaptec.com>,
       Hannes Reinecke <hare@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       James Smart <james.smart@emulex.com>,
       Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org,
       open-iscsi@googlegroups.com
Subject: Re: [PATCH] drivers/scsi/: Spelling fixes
References: <1197920439-5455-8-git-send-email-joe@perches.com>
In-Reply-To: <1197920439-5455-8-git-send-email-joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 57ce225..3cc21f5 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1121,7 +1121,7 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
>   * iscsi_sendhdr - send PDU Header via tcp_sendpage()
>   * @conn: iscsi connection
>   * @buf: buffer to write from
> - * @datalen: lenght of data to be sent after the header
> + * @datalen: length of data to be sent after the header
>   *
>   * Notes:
>   *	(Tx, Fast Path)
> @@ -1724,7 +1724,7 @@ send_hdr:
>   *	XMSTATE_BIT_SOL_DATA     - send solicit data
>   *
>   *iscsi_tcp_ctask_xmit
> - *	XMSTATE_BIT_IMM_DATA     - xmit managment data (??)
> + *	XMSTATE_BIT_IMM_DATA     - xmit management data (??)
>   **/
>  static int
>  iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)

Olaf rewrote this code and it will not exist when James merges the 
patches, so you can drop the iscsi bits.
