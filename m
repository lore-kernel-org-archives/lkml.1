Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbXEWJQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbXEWJQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759913AbXEWJQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:16:17 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:49650 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbXEWJQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FjICF3RBVxCqBnsq4tq+UsO5ZEqMrejUrISCXTipuD6LjAHwRcZhHjwrFXxe/LQjdUXvesFYa+Rj2zC2p39o3K4UONLtDIcYUSpPiPozyEzmxBBB1iD9K/tUy87aWRbd5dQ3ZrD3GFUEIJTmNc/pHQ63oibj2MuJcmrhqKVApgs=
Message-ID: <4de7f8a60705230216n4425e19bqddd8b54b6a0ff74a@mail.gmail.com>
Date: Wed, 23 May 2007 11:16:13 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] file as directory
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
	 <20070522221045.GH4095@ftp.linux.org.uk>
	 <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
	 <20070523070306.GM4095@ftp.linux.org.uk>
	 <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu>
	 <20070523073658.GO4095@ftp.linux.org.uk>
	 <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu>
X-Google-Sender-Auth: ca85bf25742d16c6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> So your question is, which mount takes priority on the lookup?  It
> probably should be the propagated real mount, rather than the
> dir-on-file one, shouldn't it?
>

Maybe this might belong into __link_path_walk() similar to the
handling of symbolic links. If the real mount has always higher
priority why do we bother in follow_mount() about it.

Jan
