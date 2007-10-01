Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXJALw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXJALw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXJALwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:52:19 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:33689 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXJALwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:52:18 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Mon, 1 Oct 2007 14:52:03 +0300
Message-Id: <20071001114715.M51349@nuclearcat.com>
In-Reply-To: <20071001111441.GA17357@one.firstfloor.org>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au> <20070930220452.M25621@nuclearcat.com> <p73myv36tmz.fsf@bingen.suse.de> <20071001103026.M59805@nuclearcat.com> <20071001111441.GA17357@one.firstfloor.org>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 194.146.154.161 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

No major differences. 
Some procedures higher a bit, some lower a bit, but everything looks fine on
both kernels.

Thats what i tried first - oprofile, and only one keypoint i was able to catch
- in top softirqd/0 or /1 shows usage 100% cpu, and in mpstat - soft% also
reaching 100%. 



On Mon, 1 Oct 2007 13:14:41 +0200, Andi Kleen wrote
> On Mon, Oct 01, 2007 at 01:30:52PM +0300, Denys wrote:
> > 
> > Already i did, and it didn't show real failure point.
> 
> There was no difference between the profile of the working kernel
> and the high load kernel?  Perhaps you just have legitimate higher load?
> 
> -Andi


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

