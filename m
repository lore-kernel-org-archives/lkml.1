Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYAZUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYAZUU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYAZUUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:20:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51873 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYAZUUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:20:17 -0500
Date: Sat, 26 Jan 2008 20:20:10 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unifdef linux/vt.h
Message-ID: <20080126202010.GA28444@infradead.org>
References: <20080125180215.GA30039@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125180215.GA30039@aepfle.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 07:02:15PM +0100, Olaf Hering wrote:
> 
> remove the newly added __KERNEL__ block from linux/vt.h
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

We shouldn't add more unifdef-y headers.  Please move the newly-added
kernel-only section to a different file instead and beat up the person
who introduced it with a big cluestick.
