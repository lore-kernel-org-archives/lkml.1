Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYBFPYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYBFPYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYBFPX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:23:57 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59426 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbYBFPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:23:57 -0500
Date: Wed, 6 Feb 2008 10:23:56 -0500
To: Marc Donner <donner@dbd-breitband.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dma error on boot with cf card
Message-ID: <20080206152356.GC26257@csclub.uwaterloo.ca>
References: <200802051852.29592.donner@dbd-breitband.de> <20080205185628.GF26259@csclub.uwaterloo.ca> <200802060954.53802.donner@dbd-breitband.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802060954.53802.donner@dbd-breitband.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 09:54:53AM +0100, Marc Donner wrote:
> and how do i disable dma? it is the installer image, and no hdparm is 
> availible. and the ide=nodma boot parameter seems not to work. 

ide=nodma works for me on 2.6.18.  I think on newer kernels you need
hda=nodma which is nice since you can control it per device rather than
globally.

--
Len Sorensen
