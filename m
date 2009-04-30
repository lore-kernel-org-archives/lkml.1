Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbZD3Gmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbZD3Gmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZD3Gmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:42:33 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:40430 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbZD3Gmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:42:32 -0400
Date: Thu, 30 Apr 2009 08:42:31 +0200
From: Max Kellermann <max@duempel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: splice() on two pipes
Message-ID: <20090430064231.GA26844@squirrel.roonstrasse.net>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20090429103308.GA23684@squirrel.roonstrasse.net> <20090430062151.GU4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430062151.GU4593@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/04/30 08:21, Jens Axboe <jens.axboe@oracle.com> wrote:
> See sys_tee().

Hm, so I could tee() from pipe1 to pipe2, then delete data from pipe1
by splicing it to /dev/null...

Max
