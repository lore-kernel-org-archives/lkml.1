Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZFAPGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZFAPGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZFAPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:06:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39339 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758436AbZFAPG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:06:27 -0400
Date: Mon, 1 Jun 2009 16:07:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 08/10] tty_io: export tty_class
Message-ID: <20090601160721.7b262469@lxorguk.ukuu.org.uk>
In-Reply-To: <1243868091-5315-9-git-send-email-dbaryshkov@gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-2-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-5-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-6-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-7-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-8-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-9-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Jun 2009 18:54:49 +0400
Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> Currently tty_class in a public variable in the tty_io.c
> Export it to the modules to allow some usefull tricks.

Thats exactly why it isn't exported. We don't want "tricks".

