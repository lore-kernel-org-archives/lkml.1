Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbXHBUSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbXHBUSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbXHBUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:18:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59323 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbXHBUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:18:22 -0400
Date: Thu, 2 Aug 2007 22:18:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
Message-ID: <Pine.LNX.4.64.0708022217220.9319@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 21:55, Guennadi Liakhovetski wrote:
>Hi
>
>I've run across the following gcc "feature":
>
>	char c[4] = "01234";
>
>gcc emits a nice warning
>
>warning: initializer-string for array of chars is too long
>
>But do a
>
>	char c[4] = "0123";
>
>and - a wonder - no warning. No warning with gcc 3.3.2, 3.3.5, 3.4.5, 
>4.1.2. I was told 4.2.x does produce a warning. Now do a

Unfortunately, gcc 4.2.1 does not produce a warning for

char a[4] = "haha";


	Jan
-- 
