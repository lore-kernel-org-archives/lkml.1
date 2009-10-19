Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZJSISt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZJSISt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZJSISs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:18:48 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23397 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZJSISs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Mon, 19 Oct 2009 04:18:48 -0400
Message-Id: <4ADC3D3C020000780001AA10@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 19 Oct 2009 09:19:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@linux.intel.com>,
       <linux-arm-kernel@lists.infradead.org>,
       <u.kleine-koenig@pengutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the
	 change to BUILD_BUG_ON
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091013092644.72c78334@hskinnemoen-d830>
 <4AD44AF10200007800019801@vpn.id2.novell.com>
 <200910191638.41299.rusty@rustcorp.com.au>
In-Reply-To: <200910191638.41299.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Rusty Russell <rusty@rustcorp.com.au> 19.10.09 08:08 >>>
>How's this?  It's not quite valid C, but it "works":

But that's not what you proposed initially, i.e. generating a link time
error if a compile time error can't be generated (and only if even a link
time error isn't possible, a run time one should be forced).

And btw., why do you think this isn't valid C?

Jan

