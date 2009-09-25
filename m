Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbZIYRIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbZIYRIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZIYRIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:08:38 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42875 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZIYRIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:08:30 -0400
Date: Fri, 25 Sep 2009 18:08:31 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, agruen@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
Message-ID: <20090925170831.GB25073@shareable.org>
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <E1Mr9ke-0005uJ-KD@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Mr9ke-0005uJ-KD@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> We could implement something similar for non-directories as well, by
> treating a NULL path parameter to openat() to mean - reopen:
> 
>   fd2 = openat(fd, NULL, O_RDWR);

It would be nice to make this behavior consistent across all the *at()
functions where it is acceptable.

-- Jamie
