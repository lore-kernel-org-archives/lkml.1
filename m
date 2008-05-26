Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbYEZAdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbYEZAdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 20:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYEZAdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 20:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYEZAdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 20:33:05 -0400
Message-ID: <483A0404.6030301@zytor.com>
Date: Sun, 25 May 2008 17:27:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Tom Spink <tspink@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <20080524153611.GA13890@uranus.ravnborg.org> <48383830.6060504@goop.org> <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com> <48383C26.5040106@goop.org> <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com> <48387CCB.1030801@goop.org> <48387DF0.7000600@zytor.com> <48387FE7.2080608@goop.org> <48388097.3060707@zytor.com> <4838855F.2090701@goop.org> <20080525235743.GO1791@cs181133002.pp.htv.fi>
In-Reply-To: <20080525235743.GO1791@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> We do not have any serious problems where we actually depend on 
> randconfig.
> 
> randconfig is nice, but even if it would suddenly become no longer 
> available we wouldn't have significantely more build breakages in 
> stable kernels (perhaps a few more in the pathological cornercases
> only randconfig hits).
> 
> If this was really "the whole point" it wasn't not worth it.
> 
> Real value would come from getting errors for mistyped kconfig variable 
> names.
> 

Indeed.  However, getting at least compiler coverage across all branches 
of code is worth something, at least.

	-hpa
