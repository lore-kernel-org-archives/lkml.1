Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXFITes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXFITes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbXFITem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:34:42 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:39365 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbXFITel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:34:41 -0400
Date: Sat, 9 Jun 2007 21:34:36 +0200 (CEST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: dummy@foobar-g4
To: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bashisms from scripts/extract-ikconfig
In-Reply-To: <2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu>
Message-ID: <alpine.DEB.0.99.0706092132200.8312@foobar-g4>
References: <alpine.DEB.0.99.0706092117580.8312@foobar-g4>
 <2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Julio M. Merino Vidal wrote:
> Wouldn't this be better expressed as:
>
>   start=$(($start + 8))
>   size=$(($end - $start))
>
> to avoid invoking a subshell?

This is certainly possible for lots for scripts, but was not the "scope" 
of this patch. ` is not bash-specific and does not break anything.

-- 
make bzImage, not war
