Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYEMTqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYEMTqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbYEMTqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:46:24 -0400
Received: from 1wt.eu ([62.212.114.60]:4305 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYEMTqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:46:23 -0400
Date: Tue, 13 May 2008 21:46:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080513194612.GV8474@1wt.eu>
References: <4829326A.6060808@t-online.de> <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com> <4829D345.7020909@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4829D345.7020909@t-online.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 07:43:33PM +0200, Harald Dunkel wrote:
> Vegard Nossum wrote:
> >
> >Can you try to run "strace su someuser" instead?
> >
> 
> I tried, but its a Heisenbug: If I run it with strace (with or without
> -f), then it doesn't get stuck.

even as root ? Because if you run strace on "su" as a user, you will
lose the setuid which may change the conditions.

Willy

