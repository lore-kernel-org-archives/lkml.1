Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYGLHHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYGLHHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYGLHHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:07:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2588 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbYGLHHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:07:09 -0400
Date: Sat, 12 Jul 2008 09:01:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [2/3] POHMELFS: Documentation.
Message-ID: <20080712070150.GD13483@ucw.cz>
References: <20080707180736.GA15687@2ka.mipt.ru> <20080707181019.GC15687@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707181019.GC15687@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> + * Completely async processing of all events (hard, symlinks and rename are the
> + 	only exceptions) including object creation and data reading and writing.

Hmm... this is little funny.

	Async processing of most events (only exceptions are ...) ?


> +POHMELFS network protocol.
> +
> +Basic structure used in network communication is following command:
> +
> +struct netfs_cmd
> +{
> +	__u16			cmd;	/* Command number */
> +	__u16			csize;	/* Attached crypto information size */
> +	__u16			cpad;	/* Attached padding size */
> +	__u16			ext;	/* External flags */
> +	__u32			size;	/* Size of the attached data */
> +	__u32			trans;	/* Transaction id */
> +	__u64			id;	/* Object ID to operate on. Used for feedback.*/
> +	__u64			start;	/* Start of the object. */
> +	__u64			iv;	/* IV sequence */
> +	__u8			data[0];
> +};

Which endianity?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
