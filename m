Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZBMVQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZBMVQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbZBMVQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:16:26 -0500
Received: from outbound-mail-104.bluehost.com ([69.89.22.14]:34688 "HELO
	outbound-mail-104.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760173AbZBMVQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:16:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=RGWodVtv2SYfZGN4hcdqb18PQ5TQI+t31tTO69Z83QbuRZaT5bN5VZajX8sDp0qyUOevdPotC6401TcHTC3pYiM/BQ03Wy2Ly26ZA/2Ou8QaQr4/WrM/lZOyxqOL837N;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 4/6] drivers/pci: introduce missing kfree
Date: Fri, 13 Feb 2009 13:16:22 -0800
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0902082244490.25891@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0902082244490.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131316.23071.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 8, 2009 1:45 pm Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Error handling code following a kmalloc should free the allocated data.
> Since the subsequent code that could provoke an error does not use the
> allocated data, the allocation is just moved below it.
>
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

Applied to my linux-next branch, thanks.
-- 
Jesse Barnes, Intel Open Source Technology Center
