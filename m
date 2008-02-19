Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYBSAjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYBSAjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYBSAjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:39:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYBSAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:39:05 -0500
Message-ID: <47BA2521.3050707@zytor.com>
Date: Mon, 18 Feb 2008 16:38:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Nicol <davidnicol@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: boot parameter to override a built-in initramfs?
References: <934f64a20802181347q43e1b350tc61265e89b7e4d5c@mail.gmail.com>
In-Reply-To: <934f64a20802181347q43e1b350tc61265e89b7e4d5c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Nicol wrote:
> noinitrd doesn't do anything; init=/bin/sh doesn't do anything
> 
> how does one override a built-in initramfs?

One doesn't, because the system relies on certain pieces to be able to 
execute the rest of the root-mounting sequence.

	-hpa
