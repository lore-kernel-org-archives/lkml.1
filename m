Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZDGRnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZDGRnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZDGRmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:42:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53880 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZDGRmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:42:55 -0400
Date: Tue, 7 Apr 2009 19:44:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] romfs: cleanup romfs_fs.h
Message-ID: <20090407174457.GA13089@uranus.ravnborg.org>
References: <20090407160708.GA11384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407160708.GA11384@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 06:07:08PM +0200, Christoph Hellwig wrote:
> There's no kernel-only content in it anymore, so move it to header-y
> and remove the superflous #ifdef __KERNEL__.

today there is no difference between header-y and unifdef-y.
We pass everything through unifdef these days.

	Sam
