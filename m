Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbYJNN1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbYJNN1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYJNN1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:27:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34330 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbYJNN1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:27:23 -0400
Date: Tue, 14 Oct 2008 14:27:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 2/6] Blackfin Serial Driver: Add a debug function to
 serial driver.
Message-ID: <20081014142701.72090868@lxorguk.ukuu.org.uk>
In-Reply-To: <1223891185-13924-3-git-send-email-cooloney@kernel.org>
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
	<1223891185-13924-3-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		cpu_relax();
> +		barrier();
> +

Seems to be an odd unrelated change ?

