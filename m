Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZKTSZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZKTSZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZKTSZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:25:30 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:62123 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZKTSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:25:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=srqvxeu+VRJIwlT6t2J0zlG8vdcn9AQrkz9yj8WDYLu4fppVaJSaa1PHsRac9KA0ar
         2DaQXXBQt48e3NSHuxdwHIcfXjY6YXXT+X2gQ+sdcusNwSxMobyOER5NkJS9ws3kFHky
         tXauwQbsa2/qL5QF7rv8fQNtRhTDTz+2jBV9I=
Date: Fri, 20 Nov 2009 10:25:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-input@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: ads7846 touchscreen: fix pressure
Message-ID: <20091120182528.GB16447@core.coreip.homeip.net>
References: <20091120182238.GA1344@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120182238.GA1344@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:22:39PM +0100, Pavel Machek wrote:
> 
> On Zaurus, pressure is reported inverted -- the lighter the pressure,
> the bigger numerical value. This should fix it.
> 

Thanks. Didn't you also have a bigger cleanup patch for ads7846?

-- 
Dmitry
