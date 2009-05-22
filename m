Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbZEVPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbZEVPJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbZEVPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:09:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756486AbZEVPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:09:13 -0400
Date: Fri, 22 May 2009 16:10:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tom.leiming@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core : fix request_firmware_nowait
Message-ID: <20090522161016.36ef6f15@lxorguk.ukuu.org.uk>
In-Reply-To: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com>
References: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 23:06:27 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> request_firmware_nowait declares it can be called in non-sleep contexts,
> but kthead_run which is called by request_firmware_nowait may sleep.

Does anyone actually need to call it in a non-sleeping context or can the
documentation simply be fixed instead to avoid all the extra complexity ?
