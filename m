Return-Path: <linux-kernel-owner+w=401wt.eu-S1763720AbXHWUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763720AbXHWUIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXHWUIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:08:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbXHWUIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:08:10 -0400
Message-ID: <46CDE914.1030400@zytor.com>
Date: Thu, 23 Aug 2007 13:07:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gerald Britton <gbritton@doomcom.org>
CC: Michael Smith <msmith@xiph.org>, linux-kernel@vger.kernel.org,
       Andy Wingo <wingo@fluendo.com>
Subject: Re: gettimeofday() jumping into the future
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <20070823113648.GA5405@zante.sekrit.org>
In-Reply-To: <20070823113648.GA5405@zante.sekrit.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerald Britton wrote:
> I have seen this as well (on a 2.6.20.4 kernel).  The value returned was
> always identical each time the glitch occured (just a little over 4398
> seconds).

I would guess an off by 2^32 error is at play.

	-hpa
