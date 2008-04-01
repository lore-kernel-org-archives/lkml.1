Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYDALQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYDALQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbYDALQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:16:45 -0400
Received: from lazybastard.de ([212.112.238.170]:58346 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYDALQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:16:45 -0400
Date: Tue, 1 Apr 2008 13:16:28 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401111627.GF7465@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru> <20080401091945.GB7465@logfs.org> <47F20464.4070202@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F20464.4070202@yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 April 2008 12:46:12 +0300, Artem Bityutskiy wrote:
> Jörn Engel wrote:
> >Write-back of data: currently not.
> 
> Taking into account this, bad block handling and other stuff I kindly ask 
> you
> not to do these "tricky" things like comparing amount of code lines.
> I believe if you implement all the things, you'll have _way_ more code. I
> believe you'll even have to re-design many things because write-back really
> affects the design a lot. Let's be fair.

Take those numbers with as much salt as you like.  Implementing
write-back caching for metadata actually reduced the line count by 100
or so.  And it did affect the design a lot, I agree.

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
