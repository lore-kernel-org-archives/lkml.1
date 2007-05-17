Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbXEQUTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbXEQUTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXEQUSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:18:55 -0400
Received: from gw.goop.org ([64.81.55.164]:39009 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbXEQUSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:18:54 -0400
Message-ID: <464CB8A9.9030700@goop.org>
Date: Thu, 17 May 2007 13:18:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, dedekind@infradead.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] ubi: kill homegrown endian macros
References: <20070517143200.GA30850@lst.de> <1179417055.2859.506.camel@shinybook.infradead.org> <20070517181223.GA17765@lst.de> <20070517182314.GA5584@uranus.ravnborg.org> <20070517183628.GA12282@infradead.org>
In-Reply-To: <20070517183628.GA12282@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>  The attribute syntax is perfecltly
> find to address endianess issues without introducing wrapper structs the
> lead to horrible code generation in some situations (e.g. trying to return
> such a value)

Small structs are returned in register; it is indistinguishable from
returning a scalar.

    J
