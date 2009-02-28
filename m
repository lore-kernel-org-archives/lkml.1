Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZB1VbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZB1VbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZB1VbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:31:13 -0500
Received: from senator.holtmann.net ([87.106.208.187]:44086 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZB1VbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:31:13 -0500
Subject: Re: [PATCH 2/3] bluetooth: add macros for cid channel numbers
From: Marcel Holtmann <marcel@holtmann.org>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235797347-1816-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
	 <1235797347-1816-2-git-send-email-gustavo@las.ic.unicamp.br>
Content-Type: text/plain
Date: Sat, 28 Feb 2009 22:30:56 +0100
Message-Id: <1235856656.6074.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

you can keep Bluetooth patches on linux-bluetooth only since they have
to go via bluetooth-testing.git first.

You are missing a commit message before the signed-off-by line. I am
serious about that every kernel patch has a proper commit message in
human readable text. No matter how simple the patch might look.

> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> ---
>  include/net/bluetooth/l2cap.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
> index f566aa1..e7bf331 100644
> --- a/include/net/bluetooth/l2cap.h
> +++ b/include/net/bluetooth/l2cap.h
> @@ -118,6 +118,13 @@ struct l2cap_conn_rsp {
>  #define L2CAP_CS_AUTHEN_PEND  0x0001
>  #define L2CAP_CS_AUTHOR_PEND  0x0002
>  
> +
> +/* cid channel type */

Use /* channel identifier */ here.

> +#define L2CAP_CID_SIGNALING	0x0001
> +#define L2CAP_CID_CONN_LESS	0x0002
> +#define L2CAP_CID_DYN_START	0x0040
> +#define L2CAP_CID_DYN_END	0xffff
> +

And put these above /* connect result */ defs.

Regards

Marcel


