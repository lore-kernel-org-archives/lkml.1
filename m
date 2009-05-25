Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZEYXQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZEYXQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZEYXQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:16:38 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46363 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZEYXQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:16:37 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Date: Tue, 26 May 2009 01:17:03 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       aeb@cwi.nl
References: <20090525205353.GB6856@redhat.com> <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org> <20090525214755.GE6856@redhat.com>
In-Reply-To: <20090525214755.GE6856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905260117.04959.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. Mai 2009 23:47:55 schrieb Michael S. Tsirkin:
> So, the following works for me as a work-around.  But it's probably not
> the appropriate way to solve the problem. Or is it? Can someone who
> understands partitions and filesystems tell?

If you are sure it is only the first failing, rather than a timing issue,
it is better to have a new quirk type that issues a dummy read in the storage
driver.

	Regards
		Oliver

