Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYKGTby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYKGTby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYKGTbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:31:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbYKGTbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:31:46 -0500
Date: Fri, 7 Nov 2008 11:31:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: djwong@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ics932s401: New driver
Message-Id: <20081107113142.80d3b460.akpm@linux-foundation.org>
In-Reply-To: <20081107191110.13201.20476.stgit@elm3a70.beaverton.ibm.com>
References: <20081107191110.13201.20476.stgit@elm3a70.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are nice-looking drivers and I'm inclined to slip them into
2.6.28, but..

On Fri, 07 Nov 2008 11:11:10 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> +/* Addresses to scan */
> +static const unsigned short normal_i2c[] = { 0x69, I2C_CLIENT_END };

These are the sorts of drivers which must go blindly poking at
hardwired IO addresses, aren't they?  So if someone accidentally
compiles it up and loads it, it will reach out and fry their pr0n
collection?


