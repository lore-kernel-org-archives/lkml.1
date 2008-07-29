Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbYG2R2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbYG2R2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYG2R2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:28:06 -0400
Received: from gw.goop.org ([64.81.55.164]:52758 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYG2R2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:28:05 -0400
Message-ID: <488F5321.201@goop.org>
Date: Tue, 29 Jul 2008 10:28:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Oliver.Soltys@rsel.renesas.com, linux-kernel@vger.kernel.org
Subject: Re: directory sort order no longer beginning with "." and ".."?
References: <488EE7BF.4020908@rsel.renesas.com> <488F2EDA.2090709@goop.org> <2c0942db0807290935s67eba63te5bb826a0ab7c752@mail.gmail.com>
In-Reply-To: <2c0942db0807290935s67eba63te5bb826a0ab7c752@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> That's a good idea, though based on his description it's even easier.
> The LD_PRELOAD just needs to artificially introduce . and .., at the
> beginning and toss them out once it hits them in the list. No sorting
> required.
>   
You'd have to be careful with respect to seekdir/telldir, but that may 
not matter if its just an app-specific hack.

    J
