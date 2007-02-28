Return-Path: <linux-kernel-owner+w=401wt.eu-S1750926AbXB1Bp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbXB1Bp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXB1Bp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:45:27 -0500
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:57671 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXB1Bp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:45:26 -0500
In-Reply-To: <45E46976.6060600@freescale.com>
References: <45E46976.6060600@freescale.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <29c13109971547687159078eacdea008@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 02:45:22 +0100
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  		 46 = /dev/ttyCPM0		PPC CPM (SCC or SMC) - port 0
>  		    ...
> -		 47 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 5
> +		 49 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 5

If CPM0 is 46, then CPM5 is not 47, but not 49 either.
Unless it's not CPM5 but CPM3?


Segher

