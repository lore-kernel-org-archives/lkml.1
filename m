Return-Path: <linux-kernel-owner+w=401wt.eu-S1751214AbXBMJSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbXBMJSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXBMJSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:18:30 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:57669 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXBMJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:18:29 -0500
Subject: Re: [PATCH mm] cfag12864b: fix crash when built-in and no parport
	present
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <maxextreme@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070212213557.4b28e567.akpm@linux-foundation.org>
References: <20070210205123.699abb9c.maxextreme@gmail.com>
	 <20070212213557.4b28e567.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 01:16:36 -0800
Message-Id: <1171358197.32073.182.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 21:35 -0800, Andrew Morton wrote:

> 
> This looks hacky.
> 

One other thing that could be added is a change in the initcalls .
ks0108 should be subsys_initcall() and the LCD devices
device_initcall(). That would make sure one runs before the other. I
don't think that alone would fix the crash tho. I didn't suggest it
before cause I think the order of the sources in the build system might
do this implicitly even if both are in device_initcall ..

Daniel

