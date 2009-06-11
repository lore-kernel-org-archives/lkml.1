Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbZFKWCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbZFKWCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759357AbZFKWCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:02:14 -0400
Received: from windsormachine.com ([216.8.138.2]:40456 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbZFKWCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:02:14 -0400
Date: Thu, 11 Jun 2009 18:02:15 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: Felix Blyakher <felixb@sgi.com>
cc: Eric Sandeen <sandeen@sandeen.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many
 processes
In-Reply-To: <8EE3C044-FB47-46BC-A06F-DA0EF65D8236@sgi.com>
Message-ID: <alpine.DEB.1.10.0906111759470.25044@router.windsormachine.com>
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan> <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan> <4A313F84.20900@sandeen.net> <8EE3C044-FB47-46BC-A06F-DA0EF65D8236@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Jun 2009, Felix Blyakher wrote:
>  xfs: fix getbmap vs mmap deadlock

Any chance that's related to the issues seen in 
http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?

Seems to be kswapd dying in our case.

Mike

