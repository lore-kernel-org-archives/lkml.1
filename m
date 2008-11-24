Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbYKXITz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbYKXITz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYKXITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:19:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:55902 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYKXITq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iE0bfJTD1Nb4pM7l6vMS/Gjhz9IhUpdFN8yqppWtIhgbkdbURkD7BT3pzrhOKZA2tA
         XwL73yWx7/UP6QaJxzRbUgjFLnkoYYPId/zhBgSTsueipMBXNBJNZgMEVXpJ2rZAIiA7
         bW9dnCjMFSVokVpJvRRqPAh5J0AspI/X3cCV0=
Message-ID: <84144f020811240019u53754541kf585b6a21462db3b@mail.gmail.com>
Date: Mon, 24 Nov 2008 10:19:45 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <1227514564.3718.17.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201135l7b83404etb311a7b62390dd19@mail.gmail.com>
	 <1227269248.7015.31.camel@pc1117.cambridge.arm.com>
	 <1227514564.3718.17.camel@penberg-laptop>
X-Google-Sender-Auth: 5e6fda3a4abbd45d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 10:16 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> OK, but I don't really see any fundamental reason why we couldn't do
> this. I mean, from my point of view, it would be better to add
> specialized hooks (i.e. separate allocation paths for the kmemleak hooks
> that avoid any issues) inside the SLAB allocators rather than invent a
> separate allocator. As an example,

Oops, I don't know where that "as an example" part came from so just
ignore it. :-)
