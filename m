Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYHZKbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYHZKbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYHZKbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:31:23 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:37182 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbYHZKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:31:22 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Tue, 26 Aug 2008 13:29:53 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080826095126.GA2609@ff.dom.local>
In-Reply-To: <20080826095126.GA2609@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261329.53741.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, Jarek Poplawski wrote:
>
> This function is really used in many places, and these profiles are
> not enough at least to me, but it seems you could have a lot of
> softirqs (and probably hrtimers) scheduling, so maybe you should try
> if e.g. disabling hrtimers or changing kernel HZ makes any difference.
>
> Jarek P.
One user is shapers, it is ok for me.
I am not sure, but maybe another user is softlockup debug option... and if 
there is a lot of task switches maybe it will cause excessive load of timers 
slow?

