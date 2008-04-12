Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYDLPra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYDLPra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYDLPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:47:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:13231 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYDLPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bCXwx3d3/K27gMTEWtR0yJ9uykaKDYuE1gqHVut/YxQPsmtz4iQnVxUCxZNz8dUYcWU2tiIXaJMnOheAxe+5jRYAR/5hp5/eWdajxgE01QEQpDD1fluCQfLBRY/vM2NYVVrsmmYH6Diw6WU5OmEQA0ie0PlI6SVK70fDbsQACjc=
Date: Sat, 12 Apr 2008 11:47:11 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Message-ID: <20080412154711.GA3221@anvil.corenet.prv>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207946244-14525-4-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

On Fri, Apr 11, 2008 at 05:37:19PM -0300, Henrique de Moraes Holschuh wrote:
> The *_RADIO input events are related to all radios in a system.  There are
> two: KEY_RADIO and SW_RADIO.
> 

KEY_RADIO is reserved for selecting radio input (as pooosed to TV, AUX,
etc) with a remote control. Rfkill woudl need a separate keycode if it
needs "all types of radios" event.

Btw, is there any devices in the wild that actually have separate
switches for different types of transmitters?

-- 
Dmitry
