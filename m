Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbYHERsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbYHERsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762477AbYHERr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:47:56 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3676 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761089AbYHERrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:47:55 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: BUG:tg3_open() bug
From: "Michael Chan" <mchan@broadcom.com>
To: "Ming Lei" <tom.leiming@gmail.com>
cc: "David Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <d82e647a0808050732u8c5343doba5cd7bc7248087c@mail.gmail.com>
References: <d82e647a0808050732u8c5343doba5cd7bc7248087c@mail.gmail.com>
Date: Tue, 05 Aug 2008 06:47:17 -0700
Message-ID: <1217944037.8694.3.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 64864DC83D0113563296-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-08-05 at 07:32 -0700, Ming Lei wrote:
> BUG: scheduling while atomic: ifconfig/3345/0x00000102

The patch to fix this has been applied to the net-2.6 tree last night:

tg3: Fix 'scheduling while atomic' errors


