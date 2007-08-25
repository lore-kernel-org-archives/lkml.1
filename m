Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXHYWDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXHYWDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHYWDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:03:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51911 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXHYWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:03:45 -0400
Date: Sat, 25 Aug 2007 14:57:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hare@suse.de
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Message-ID: <20070825145742.69b99168@laptopd505.fenrus.org>
In-Reply-To: <200708252257.07241.vda.linux@googlemail.com>
References: <200708252257.07241.vda.linux@googlemail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 22:57:07 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi,
> 
> Attached patch deinlines and moves big functions from .h to .c files
> in drivers/scsi/aic7xxx/*. I also had to add prototypes for
> ahc_lookup_scb and ahd_lookup_scb to .h files.
> 

one question... how many of these can actually be static (or would be
if they were in their only-caller-c-file) ? Did you run the find static
script or are you waiting for Adrian to do that ;-)
