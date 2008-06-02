Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYFBR62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYFBR62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYFBR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:58:17 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:42655 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYFBR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:58:16 -0400
Date: Mon, 2 Jun 2008 14:58:00 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: casey@schaufler-ca.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smack: fuse mount hang fix
Message-ID: <20080602145800.0e0d0c73@mandriva.com.br>
In-Reply-To: <48442820.3080400@schaufler-ca.com>
References: <48442820.3080400@schaufler-ca.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 02 Jun 2008 10:04:32 -0700
Casey Schaufler <casey@schaufler-ca.com> escreveu:

| From: Casey Schaufler <casey@schaufler-ca.com>
| 
| The d_instantiate hook for Smack can hang on the root
| inode of a filesystem if the file system code has not
| really done all the set-up. Fuse is known to encounter
| this problem. This change detects an attempt to
| instantiate a root inode and addresses it early in the
| processing, before any attempt is made to do something
| that might hang.
| 
| Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

 Fixed the problem for me, thank very much.

Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

-- 
Luiz Fernando N. Capitulino
