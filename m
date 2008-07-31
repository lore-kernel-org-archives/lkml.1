Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYGaTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYGaTIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYGaTIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:08:05 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:54335 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754565AbYGaTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:08:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=QwvWDXO8tGMRwCDGaD/V+BR/BPviur4K4hyC6KVIVk/uQ9ndcPZDOnWqPdhMhw4c7GNpNodt7RIDi7bbPusaWWa8PzC2whNBAFUx3rGJ+kD5YTzBZ5JBDkHUPtDNvE9e;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dieter Ries <clip2@gmx.de>
Subject: Re: suspend to  ram regression in current GIT, bisected
Date: Thu, 31 Jul 2008 12:07:49 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, willy@linux.intel.com, pavel@suse.cz,
       len.brown@intel.com, linux-pm@lists.linux-foundation.org, rjw@sisk.pl
References: <48920CF7.4060907@gmx.de>
In-Reply-To: <48920CF7.4060907@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311207.49335.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2008 12:05 pm Dieter Ries wrote:
> Hi,
>
> starting from 2.6.27-rc1, my Laptop (Thinkpad T60) did not return from
> suspend to ram anymore.
>
> When it should resume, the sleep LED went off, power went on, HD LED
> flashed once, but the display stayed black.

Can you test the fix in http://bugzilla.kernel.org/show_bug.cgi?id=11178?  
Hopefully it's a DUP.

Thanks,
Jesse
