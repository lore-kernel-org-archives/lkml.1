Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbXGLNfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbXGLNfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761635AbXGLNfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:35:08 -0400
Received: from rtr.ca ([64.26.128.89]:4723 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759284AbXGLNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:35:07 -0400
Message-ID: <46962E09.40606@rtr.ca>
Date: Thu, 12 Jul 2007 09:35:05 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: david@aeolia.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hard drive - dead or dying?
References: <1184222444.5969.0.camel@ceres>
In-Reply-To: <1184222444.5969.0.camel@ceres>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Sumbler wrote:
> My computer (Ubuntu Feisty) would not boot correctly a few days
> ago: it seemed to get into a loop with the following printed about
> every 7 seconds (all laboriously copied in longhand, since it wasn't
> logged!):
> 
> ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.01: (BMDMA stat 0x65)
> ata1.01: cmd c8/00:08:80:b4:a8/00:00:00:00:00/f4 tag0 cdb 0x0 data 4096
> in
>          res 51/01:08:80:b4:a8/00:00:00:00:00/f4 Emark 0x1 (device error)

Use 'smartctl' to find out what the drive is having issues with.

-ml
