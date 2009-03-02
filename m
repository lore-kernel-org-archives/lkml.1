Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZCBXDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZCBXDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZCBXCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:02:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33924 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757312AbZCBXCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:02:49 -0500
Date: Mon, 2 Mar 2009 23:02:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 2/2] Input: add wm97xx accelerated driver for AVR32
	AT32AP700X microprocessors
Message-ID: <20090302230244.GA31790@opensource.wolfsonmicro.com>
References: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1236000228-13025-2-git-send-email-broonie@opensource.wolfsonmicro.com> <49ABEE83.904@gmail.com> <49AC5EB2.3050805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AC5EB2.3050805@gmail.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 11:33:22PM +0100, Jiri Slaby wrote:

> Ah, it's in the opposite way. This one is fine, the patch 1/2 should use  
> disable_irq_nosync(), if I understand the code correctly.

Actually it makes no odds either way for zylonite (it can be guaranteed
to be uniprocessor) but I'll change it for next time I spin.
