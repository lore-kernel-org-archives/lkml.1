Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbXFATVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbXFATVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761971AbXFATVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:21:37 -0400
Received: from outbound-mail-41.bluehost.com ([69.89.18.10]:39362 "HELO
	outbound-mail-41.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761887AbXFATVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:21:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Fri, 1 Jun 2007 12:21:31 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011210.15808.jbarnes@virtuousgeek.org> <Pine.LNX.4.64.0706011519080.6696@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706011519080.6696@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011221.31991.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 1, 2007 12:19:12 Justin Piszcz wrote:
> It works ok on
> my machine (correctly detects the condition, adjusts end_pfn, and keeps
> the machine fast), aside from the fact that X won't start.
>
> But X won't start? :\

Oh yeah, forgot about that. :)  Somehow the patch breaks X startup, probably 
by doing something bad to the MTRR API... but I don't know what yet.

Jesse 
