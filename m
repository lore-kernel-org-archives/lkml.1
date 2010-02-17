Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0BQQcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:32:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44244 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795Ab0BQQcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:32:41 -0500
Date: Wed, 17 Feb 2010 16:31:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vt: Fix refcounting use
Message-ID: <20100217163135.120c4bc1@lxorguk.ukuu.org.uk>
In-Reply-To: <4B7C0DBB.5010801@rsk.demon.co.uk>
References: <20100217131931.17289.68158.stgit@localhost.localdomain>
	<20100217132317.17289.61570.stgit@localhost.localdomain>
	<4B7C0DBB.5010801@rsk.demon.co.uk>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is the only bit that immediately stands out..
> maybe?
> 	if (rep || !tty) {
> 		if (tty)
> 			tty_kref_put(tty);
> 		return;
> 	}

tty_kref_put(NULL) is valid - otherwise a lot of other code (and
programmers) would go nuts..

Alan
