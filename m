Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZEFSon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZEFSon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbZEFSod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:44:33 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45950 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZEFSoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:44:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Wed, 6 May 2009 20:44:38 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: david-b@pacbell.net, lihong.hi@gmail.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <200905061534.53521.oliver@neukum.org> <20090506113117.ba254f75.akpm@linux-foundation.org>
In-Reply-To: <20090506113117.ba254f75.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905062044.38475.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Mai 2009 20:31:17 schrieb Andrew Morton:
> > > There must be some particular action which flips the thread of control
> > > from one state to the other.  eg, taking of a lock.
> >
> > Basically assigning an interface to the storage or ub driver.
>
> That's hardly enough information for anyone to understand what you
> mean :(

But isn't that always the same? If you take a lock that a method in the block
IO takes, you must use GFP_NOIO. What exactly do you want me to explain
better?

	Regards
		Oliver



