Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYC0Qta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYC0Qta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbYC0QtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:49:22 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:25047 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbYC0QtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I2+nTZTa3VyV2mCHF2OyQXuV0lJ7ev/cKSy2sukOy8I2JYC4ipa/EREacYFrGXa8vhGt5/kgQhQN9IjQuzmijt9mrjtAbWvD8PRgShEqrFO24aNZgQjpnWyz/WmlttsIGMsJeI0OpiMjPKthSTkZEYV0AMO+eqnyacdynbmqhe4=
Message-ID: <2f11576a0803270949g5931445fp8410c898c3685437@mail.gmail.com>
Date: Fri, 28 Mar 2008 01:49:20 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH] Uninline zonelist iterator helper functions
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@gmail.com
In-Reply-To: <20080327155144.GA7120@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327155144.GA7120@csn.ul.ie>
X-Google-Sender-Auth: 3b8823cefd01a12e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Mar 28, 2008 at 12:51 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> for_each_zone_zonelist_nodemask() uses large inlined helpers. The number of
>  callsites using it means that the size of the text section is increased.
>  This patch uninlines the helpers to reduce the amount of text bloat.
>
>  Signed-off-by: Mel Gorman <mel@csn.ul.ie>

I found no bug :)
