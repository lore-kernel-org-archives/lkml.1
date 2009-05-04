Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZEDGyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZEDGyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZEDGx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:53:59 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46533 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZEDGx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:53:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Li Hong <lihong.hi@gmail.com>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Mon, 4 May 2009 08:54:03 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <200905031909.14101.oliver@neukum.org> <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com>
In-Reply-To: <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905040854.03329.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. Mai 2009 05:38:33 schrieb Li Hong:
> The key is: is there any need or probability to use GFP_NOIO instead
> of GFP_KERNEL _here_? It also confuses me to move the user space copy
> outside of the loop.

No. To make it plain. To me any use of memdup_user() in USB code
is a bad idea. I don't want to have to think about a new primitive.

	Regards
		Oliver

