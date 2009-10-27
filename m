Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZJ0Q5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZJ0Q5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZJ0Q5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:57:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:55746 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbZJ0Q5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:57:16 -0400
Message-ID: <4AE7262B.1060703@gmail.com>
Date: Tue, 27 Oct 2009 17:56:11 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
References: <4AE72079.4030504@simula.no>
In-Reply-To: <4AE72079.4030504@simula.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 27 Oct 2009 17:57:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Petlund a écrit :
> This patch will make TCP use only linear timeouts if the stream is thin. This will help to avoid the very high latencies that thin stream suffer because of exponential backoff. This mechanism is only active if enabled by iocontrol or syscontrol and the stream is identified as thin.
> 

Wont this reduce the session timeout to something very small, ie 15 retransmits, way under the minute ?

