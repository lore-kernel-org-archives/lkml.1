Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZECQ3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZECQ3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZECQ2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:28:55 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:43218 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZECQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:28:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Li Hong <lihong.hi@gmail.com>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Sun, 3 May 2009 18:28:55 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: oliver@neukum.name, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
In-Reply-To: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031828.56840.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 3. Mai 2009 18:00:56 schrieb Li Hong:
> Replace a combination call of kmalloc() and copy_from_user() with
> memdup_user().

I must veto this. We lose the obvious GFP_KERNEL here. If we have
to change this for some reason we are screwed.

	Sorry
		Oliver

