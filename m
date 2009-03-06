Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZCFWjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZCFWjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbZCFWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:38:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565AbZCFWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:38:56 -0500
Date: Fri, 6 Mar 2009 14:38:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sonic.zhang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 05/18] Blackfin Serial Driver: fix bug - serial port
 transfer big file from host to target would have more lines
Message-Id: <20090306143810.5ad2c3ad.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-6-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-6-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:47 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Ignore receiving data if new position is in the same line of
> current buffer tail and small.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Changelog fails to describe the bug which is being fixed, and fails to
describe the impact of that bug and fails to explain _why_ this change
is being made.  I presently have no reason to merge this into 2.6.29.

