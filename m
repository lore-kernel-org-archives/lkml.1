Return-Path: <linux-kernel-owner+w=401wt.eu-S1764431AbXFERVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764431AbXFERVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXFERVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:21:07 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:53455 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753185AbXFERVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:21:06 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Tue, 5 Jun 2007 10:20:37 -0700
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <m1ejkrw576.fsf@ebiederm.dsl.xmission.com> <20070605094623.GA23274@one.firstfloor.org>
In-Reply-To: <20070605094623.GA23274@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051020.37812.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 5, 2007 2:46 am Andi Kleen wrote:
> > So the only safe thing we can do is not use memory that is not
> > write-back cached.  That we can positively detect and is a
> > conservative action so if anything will work that will.
>
> Jesse wrote such a patch (or rather it limitted end_pfn), but it
> broke the X server for so far unknown reasons.

It looks like I broke the /proc/mtrr interface somehow... I'll try to 
fix it tomorrow.

Jesse
