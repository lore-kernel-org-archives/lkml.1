Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYDUBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYDUBMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYDUBMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:12:09 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:40429 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbYDUBMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:12:08 -0400
Date: Sun, 20 Apr 2008 21:11:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] omfs: add bitmap routines
Message-ID: <20080421011109.GA7496@hash.localnet>
References: <1208637457-24969-7-git-send-email-me@bobcopeland.com> <20080419220307.GB7888@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419220307.GB7888@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 12:03:12AM +0200, Marcin Slusarz wrote:
> I think inner loop can be replaced with something like:
> sum += sb->s_blocksize * 8 - bitmap_weight(map, sb->s_blocksize * 8);

Yep that should work, I'll play around with that.

-- 
Bob Copeland %% www.bobcopeland.com 

