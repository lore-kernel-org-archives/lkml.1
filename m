Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXEMVU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXEMVU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXEMVUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:20:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57602 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXEMVUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:20:49 -0400
Date: Sun, 13 May 2007 22:20:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-pcmcia@lists.infradead.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pcmcia: export pcmcia_bus_type
Message-ID: <20070513212042.GA14668@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Olof Johansson <olof@lixom.net>, linux-pcmcia@lists.infradead.org,
	akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20070512153307.GA13223@lixom.net> <20070512180658.GA14291@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512180658.GA14291@lixom.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 01:06:58PM -0500, Olof Johansson wrote:
> Export pcmcia_bus_type so module-based drivers can register bus notifiers,
> and add it to what seems to be the main include file.

This all sounds rather fishy to me.  Care to send the code along that makes
use of it.

And even if we're going to add the export it should be _GPL because it's
a deeply internal implementation detail.  Then again I'm not exactly
convinced we should export it yet.

