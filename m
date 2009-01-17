Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZAQVLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZAQVLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZAQVLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:11:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZAQVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:11:38 -0500
Message-ID: <497248AE.10500@zytor.com>
Date: Sat, 17 Jan 2009 13:07:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3	warnings
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org>
In-Reply-To: <20090117204421.GA1700@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> 
> How about something utterly evil? (Since you can't pass a zero-length
> string to a printf attributed function either...)
> 

?!

*That* should definitely be permitted... anything else is an utter bug.

On the other hand, having a global empty string in the kernel isn't a
bad thing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

