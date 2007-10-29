Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXJ2PlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXJ2PlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXJ2PlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:41:14 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53186 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXJ2PlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:41:13 -0400
Message-ID: <4725FF15.5050908@tiscali.nl>
Date: Mon, 29 Oct 2007 16:41:09 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: build failure, missing libvdeplug.h?
References: <4725FB46.70802@tiscali.nl>
In-Reply-To: <4725FB46.70802@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> the file libvdeplug.h is missing

> 
> There is a reference to http://wiki.virtualsquare.org/index.php/Main_Page in
> the Kconfig (also added by this commit).
> After reverting this commit the build continues. possibly the header 
> libvdeplug.h was forgotten?

Sorry for answering myself, but apparently it can be found here:

http://vde.sourceforge.net/

I think, however that there is a 'depends on' missing in kconfig - to prevent build
failure?
