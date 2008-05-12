Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYELQ4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYELQ4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYELQzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:55:55 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:34524 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752974AbYELQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:55:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z7iNMgHxuZOu06KsJTu2u/Lcadl1BmZ+yfugrRgEerjfEN6Q2s1jotSJRZX/U78GcuE65NYUEopGGMEhXLH7ZN/iJa7LqUv+wQ6nyX0CvbFAFhpZxvWOzjvZKLFnppxLfgRTBiIgwxjrl/TmeZwQhYr6yfRK4niFGasUa5/GjF4=  ;
X-YMail-OSG: R8x3x3IVM1k0SHbKRqlbQTtJtvU1BY.0.Zjl2bKyXTwd6n0KahTPm0RsQwZo0PNtLerblXhM7OTuLk1skgmpRVX.03oa_lrHqQHKspUpnAJA51CDdNlgI7jb79Hb0CDp28Y-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Date: Mon, 12 May 2008 09:55:52 -0700
User-Agent: KMail/1.9.6
Cc: dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com,
       philipp.zabel@gmail.com, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805120955.53380.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2008, Bryan Wu wrote:
>                         unsigned int type = button->type ?: EV_KEY;
> +                       GPIOKEYS_EDGE_SENSE(0);
>                         int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;
> -
> +                       GPIOKEYS_EDGE_SENSE(1);

By the way ... don't intersperse declarations like "int state"
with code like what those EDGE_SENSE macros wraps...

