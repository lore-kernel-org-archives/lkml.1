Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZAQUFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZAQUFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZAQUEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:04:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZAQUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:04:52 -0500
Message-ID: <49723912.6020108@zytor.com>
Date: Sat, 17 Jan 2009 12:01:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3	warnings
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu>
In-Reply-To: <20090117161817.GA10825@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> hm, that's unfortunate. GCC seems totally on crack for not accepting a 
> NULL format string.
> 

Why should it?  I don't think a NULL pointer as the format to a
printf-style function is well defined.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

