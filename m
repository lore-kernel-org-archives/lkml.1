Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYATWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYATWFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 17:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYATWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 17:05:41 -0500
Received: from ozlabs.org ([203.10.76.45]:51952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbYATWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 17:05:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Subject: Re: [PATCH 2/6] typesafe: kthread_create and kthread_run
Date: Mon, 21 Jan 2008 09:04:56 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200801202046.14746.rusty@rustcorp.com.au> <87ve5otqgl.fsf@saeurebad.de> <36ca99e90801200843p7f45ef6ay281b5e77848f6d32@mail.gmail.com>
In-Reply-To: <36ca99e90801200843p7f45ef6ay281b5e77848f6d32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210904.57266.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 03:43:40 Bert Wesarg wrote:
> No, it is a matter of conforming to C99 or to GNU extensions.

Hi Bert!

Not sure I see the point of your message.

The original use the ... varargs GNU extension, your two argument version is 
the C99-safe variant, and your three args + __VA_ARGS__ uses the gcc ## 
extension.

Cheers,
Rusty.
