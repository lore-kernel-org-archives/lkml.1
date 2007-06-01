Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXFACK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXFACK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXFACKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:10:15 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbXFACKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:10:13 -0400
Date: Thu, 31 May 2007 19:10:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>
Subject: Re: [patch -mm] alsa mixer_oss kfree fix
Message-Id: <20070531191005.292efbdc.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0705311853w4df1aae8k87c55fdfbfa96b10@mail.gmail.com>
References: <a8e1da0705311853w4df1aae8k87c55fdfbfa96b10@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 01:53:39 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Fix possible null pointer kfree.

kfree(NULL) is legal, and is often used.
