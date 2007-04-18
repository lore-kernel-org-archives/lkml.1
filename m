Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXDRHtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXDRHtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbXDRHtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:49:35 -0400
Received: from duempel.org ([81.209.165.42]:49732 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932950AbXDRHte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:49:34 -0400
Date: Wed, 18 Apr 2007 09:48:59 +0200
From: Max Kellermann <max@duempel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
Message-ID: <20070418074859.GA21494@roonstrasse.net>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070418061541.GA11293@roonstrasse.net> <4625BA1A.9030808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4625BA1A.9030808@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007/04/18 08:26, Tejun Heo <htejun@gmail.com> wrote:
> Can you try it on another controller?  Say, a ahci or sil24?

Seems to work ok on a Via VT8251 controller (AHCI) on kernel
2.6.21-rc6-git4 without my NCQ disabling patch.

By the way, on this machine, I had a lot of SATA timeouts during
kernel boot, which were solved by appending "nomsi".  Do you believe
there might be a relation to the NCQ problems on my first (Nforce)
machine?

Max

