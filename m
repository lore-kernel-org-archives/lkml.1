Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYFBHGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYFBHGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYFBHG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:06:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35321 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYFBHG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:06:28 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <20080602060509.GA27519@infradead.org> (message from Christoph
	Hellwig on Mon, 2 Jun 2008 02:05:09 -0400)
Subject: Re: [patch 8/8] vfs: create file_remove_suid() helper
References: <20080529113245.450308367@szeredi.hu> <20080529113318.257547449@szeredi.hu> <20080531082934.GG24135@infradead.org> <E1K2uQk-0001dO-G7@pomaz-ex.szeredi.hu> <20080602060509.GA27519@infradead.org>
Message-Id: <E1K347b-0002eY-Ve@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Jun 2008 09:06:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which means, that that pointer dereference will be done once instead
> > of in each caller, no?  It's a gain (albeit a small one) is in code
> > cleanliness, and possibly in generated code size.
> 
> Again, it doesn't make anyhing simpler.  It might be a cleanup at best.

OK, that depends what you call simpler :)

Yes it is a cleanup.

Miklos
