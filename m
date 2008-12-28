Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYL1XlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYL1XlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYL1Xkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:40:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:19642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYL1Xkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=cDHnbLYy2hgRbxEABOqUDRmHpDJrsCbuPzNh0FuLYQDeVaWXAOQLyeDZj78ClCx8Us
         8LKUF4VobXEVQA+CjmUV1MhT5ZxgWavNPU3gGYgxB6SxIT75UAwzqtvwVV5ZhVrklU4o
         2b8zEioYbbqsdNda11lGKoRpnkR7Q6gNvZUg0=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org, alejandro.riveira@gmail.com
Subject: Re: fs/cifs/cifsfs.c Compilation error latest git
Date: Mon, 29 Dec 2008 00:39:28 +0100
User-Agent: PLD Linux KMail/1.9.10
Cc: sfrench@samba.org, linux-cifs-client@lists.samba.org
References: <1230507271.27845.4.camel@varda>
In-Reply-To: <1230507271.27845.4.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812290039.28638.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 of December 2008, Alejandro Riveira Fernández wrote:
> $ git describe
> v2.6.28-2929-g541ef5c

Something like:

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 974c8f0..79411d4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -361,8 +361,7 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
                                        switch (server->addr.sockAddr6.
                                                sin6_family) {
                                        case AF_INET6:
-                                               seq_printf(s, NIP6_FMT,
-                                                          NIP6(server->addr.sockAddr6.sin6_addr));
+                                               seq_printf(s, "%p6", &server->addr.sockAddr6.sin6_addr);
                                                break;
                                        case AF_INET:
                                                seq_printf(s, NIPQUAD_FMT,



-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
