Return-Path: <linux-kernel-owner+w=401wt.eu-S940902AbXHIPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940902AbXHIPmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938808AbXHIPmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:42:09 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:56189 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939020AbXHIPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:42:08 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
In-reply-to: <20070809153556.GB25475@fieldses.org> (bfields@fieldses.org)
Subject: Re: [RFC PATCH 1/4] pass open file to ->setattr()
References: <20070809152744.519270818@szeredi.hu> <20070809152859.787064024@szeredi.hu> <20070809153556.GB25475@fieldses.org>
Message-Id: <E1IJA8t-0006bK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Aug 2007 17:41:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is needed to be able to correctly implement open-unlink-fsetattr
> > semantics in some filesystem such as sshfs, without having to resort
> > to "silly-renaming".
> 
> How do you plan to do that?

Easy: the SFTP protocol has stateful opens and defines an FSTAT call.

Miklos
