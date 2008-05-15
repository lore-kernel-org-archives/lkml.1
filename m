Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYEONDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYEONDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYEONDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:03:24 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:32120 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751042AbYEONDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:03:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0F/zhvhlKMADs30WLGBamgLqghnvmTbK9KCDT70pe0YVrNS7QaGE4LJxaMO+IHshB0fgT2fJCf87vQp9F25WUZDQxWMNRya5Lvk6nVo0+OStB930M828axTyulgQOuDJVC39A/VpB4xHm9YRRVfJwmWSbjkxRpIX64qxxNHHca0=  ;
X-YMail-OSG: 6h1c38EVM1lX.pZUOiG4j8MsUX9yznR8xLxOJu5bnj1lg10fFdkFjx9ZJ5X7gopGIGwAG_KO9q22YiFgEfQ67G1cRyqx.WGJhOGAI7SxAuX_jfZj_BgcBihSq56AKtitwp0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Date: Thu, 15 May 2008 06:03:20 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <cooloney@kernel.org>, "Jie Zhang" <jie.zhang@analog.com>,
       harvey.harrison@gmail.com, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org> <386072610805150254p6161627er9f99910066287f2f@mail.gmail.com> <200805151419.16026.oliver@neukum.org>
In-Reply-To: <200805151419.16026.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805150603.21199.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2008, Oliver Neukum wrote:
> This is not very nice. If we pass around unaligned pointers we should mark
> those not catch errors later on.

ISTR that GCC doesn't have a way to annotate pointers that way.

