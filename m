Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZEMAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZEMAXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZEMAXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:23:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52772 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbZEMAXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:23:35 -0400
Date: Wed, 13 May 2009 01:24:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexander Y. Fomichev" <git.user@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: jsm: two or more 4/8-port boards can not initialize ports
 properly
Message-ID: <20090513012431.72a9eb83@lxorguk.ukuu.org.uk>
In-Reply-To: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
References: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct jsm_board *jsm_boards[MAXBOARDS];
> +

adapter_count increments each time regardless of boards present so that
doesn't work after a few hotplugs it seems ?

>         brd->boardnum = adapter_count++;
> +       jsm_boards[brd->boardnum] = brd;
>         brd->pci_dev = pdev;
