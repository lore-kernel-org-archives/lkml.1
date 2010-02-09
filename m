Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab0BIFf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:35:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:59679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0BIFf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:35:58 -0500
Date: Mon, 8 Feb 2010 21:36:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: chihau Chau <chihau@gmail.com>
Cc: bfields@fieldses.org, neilb@suse.de, viro@zeniv.linux.org.uk,
       Trond.Myklebust@netapp.com, bharrosh@panasas.com,
       akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: Re: [PATCH] fs: nfsd: export: fix coding style issues
Message-ID: <20100208213643.540d92a4@infradead.org>
In-Reply-To: <1265665013-32162-1-git-send-email-chihau@gmail.com>
References: <1265665013-32162-1-git-send-email-chihau@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static struct svc_expkey *svc_expkey_update(struct svc_expkey *new, struct svc_expkey *old); 
> +static struct svc_expkey *svc_expkey_update(struct svc_expkey *new,
> +							struct svc_expkey *old); 


how is this an improvement ? I don't find the 2nd more more readable

also, are you planning to do real changes to this file? If not, I would suggest not doing cleanups like this;
while cleanups like the other things you did are fine as a first step to doing real work on a file, it's usually
not liked very much to ONLY do such cosmetic things...
