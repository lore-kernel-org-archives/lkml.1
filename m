Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYHUUGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYHUUGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYHUUGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:06:02 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:27845 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYHUUGB (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uZtNxD0IF4rjsh0jE7/CIYZ+0GK8EstDlQ+XtqMOCvsLdORdu7nqC2/sfVkpCzKZ3F
         +rhqXHtKDjVj3QU1NCbl43TWLeYtQ2qPt3RocTkbFYHJV72AlNA+Wyo/I3Yg0QqxpcCB
         dXrt5l2tqx3mepkXpng292pbso7UagtFsvW/w=
Message-ID: <6934efce0808211305j349dc0fbo1cb122c0c5159ac0@mail.gmail.com>
Date: Thu, 21 Aug 2008 13:05:59 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 03/10] AXFS: axfs.h
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <200808211331.36346.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00E6.2070505@gmail.com> <200808211331.36346.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#define AXFS_PAGE_SIZE 4096
>
> What happens on systems where AXFS_PAGE_SIZE != PAGE_SIZE?

Right now, bad things I imagine.  I meant to revisit this, there was
some reason during development for this, I don't remember.  No reason
for AXFS_PAGE_SIZE I think.
