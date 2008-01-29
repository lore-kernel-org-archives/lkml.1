Return-Path: <linux-kernel-owner+w=401wt.eu-S934171AbYA2TiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbYA2TiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934109AbYA2Tho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:37:44 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:42812 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934103AbYA2Thn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:37:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Subject: Re: [PATCH] radio-si470x.c: check-after-use
Date: Tue, 29 Jan 2008 20:37:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <20080128221300.GH8767@does.not.exist> <200801282343.13589.tobias.lorenz@gmx.net>
In-Reply-To: <200801282343.13589.tobias.lorenz@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801292037.36647.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 28 Januar 2008 schrieb Tobias Lorenz:
> > Either "radio" can be NULL and this case has to be properly handled or 
> > the NULL check is not required.
> 
> These two lines should indeed better be inside the if statement. The patch for this is below.

No, in disconnect intfdata must be valid. Any check for NULL is wrong
there.

	Regards
		Oliver

