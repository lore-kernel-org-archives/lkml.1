Return-Path: <linux-kernel-owner+w=401wt.eu-S935137AbXG2PY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137AbXG2PY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXG2PH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:07:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39509 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbXG2PH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:07:27 -0400
Date: Sun, 29 Jul 2007 17:07:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ian Kent <raven@themaw.net>
cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: request for patches: showing mount options
In-Reply-To: <1185605159.8326.5.camel@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0707291703170.9488@fbirervta.pbzchgretzou.qr>
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> 
 <1185550256.3203.77.camel@raven.themaw.net>  <E1IERvH-00016M-00@dorka.pomaz.szeredi.hu>
 <1185605159.8326.5.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc trim on purpose, just autofs interest here]

On Jul 28 2007 14:45, Ian Kent wrote:
>
>Oh .. sorry, I wasn't paying enough attention.
>
>But now might be a good time to propose the removal of autofs and rename
>autofs4 to autofs. I would need to provide some way to map autofs4
>module load requests to autofs for backward compatibility but haven't
>thought about that yet.

You could use EXPORT_SYMBOL in autofs.ko that autofs4.ko uses.
Or write an autofs4.c that does try_module_get(autofs) on _init.


	Jan
-- 
