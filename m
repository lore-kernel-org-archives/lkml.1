Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYGVOnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYGVOnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYGVOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:43:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYGVOne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:43:34 -0400
Date: Tue, 22 Jul 2008 10:43:27 -0400
From: Rik van Riel <riel@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 128 GiB memory question-- kernel only sees 64GiB?
Message-ID: <20080722104327.30cee9be@bree.surriel.com>
In-Reply-To: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
References: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 10:21:44 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> To be able to utilize 128 GiB of memory on a host, does one need to enable 
> NUMA support? Currently only 64 GiB is showing up.

How much memory does the BIOS say the system has?

Can you get the e820 memory map (from early boot up) of the systems?
 
> As far as machine name/motherboard type, I do not have this information 
> currently but I am told there are one or two of these boxes are running 
> CentOS 5.x and/or RHEL5/AS.

Hopefully not with 64GB each :))
 
> Is there something special you need to do to utilize all 128 GiB of 
> memory?

You need to use a 64 bit kernel, for one.

-- 
All rights reversed.
