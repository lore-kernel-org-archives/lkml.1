Return-Path: <linux-kernel-owner+w=401wt.eu-S1946670AbXBQLvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946670AbXBQLvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946668AbXBQLvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:51:07 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:38346 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965213AbXBQLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:51:03 -0500
Date: Sat, 17 Feb 2007 12:51:15 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: exporting LANG=C (Re: [PATCH] override build timestamp)
Message-ID: <20070217115115.GA17401@aepfle.de>
References: <20070216215213.GA10732@aepfle.de> <E1HIGE5-0003WZ-Ew@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1HIGE5-0003WZ-Ew@flower>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, Oleg Verych wrote:

> While adding this functionality must be decided by kbuild developers,
> could you make separate patch with exporting 'LANG=C' on the very
> beginning and delete all other occurrences of it? It's a C header file
> generation and afaik, it must be ASCII.

That makes sense.
But we better build the whole kernel with LC_ALL=C LANG=C.
