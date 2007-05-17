Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbXEQU1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbXEQU1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbXEQU1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:27:35 -0400
Received: from main.gmane.org ([80.91.229.2]:33755 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbXEQU1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:27:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Date: Thu, 17 May 2007 20:27:20 +0000 (UTC)
Message-ID: <pan.2007.05.17.20.27.20@free.fr>
References: <20070517143200.GA30850@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cac94-1-81-57-151-96.fbx.proxad.net
User-Agent: Pan/0.125 (Potzrebie)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 16:32:01 +0200, Christoph Hellwig wrote:

> Kill ubis homegrown endianess handling crap and replace it with the
> normal kernel endianess handling.
> 
Hum, you should check about alignment stuff.
Jffs2 use a similar mechanism and the packed struct also take care of 
some unaligned data (present in summary node for example).

Matthieu

