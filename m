Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYKOHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYKOHZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 02:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYKOHZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 02:25:31 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:55692 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbYKOHZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 02:25:30 -0500
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
	are __le16
From: Jean-Francois Moine <moinejf@free.fr>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1226691865.5483.47.camel@brick>
References: <1226686796.5483.33.camel@brick> <491DCBDD.4000703@linuxtv.org>
	 <1226689669.5483.36.camel@brick>
	 <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
	 <1226690438.5483.39.camel@brick>
	 <412bdbff0811141125x34de747dm85b47f61b604219a@mail.gmail.com>
	 <1226691865.5483.47.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 15 Nov 2008 08:21:06 +0100
Message-Id: <1226733666.1730.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 11:44 -0800, Harvey Harrison wrote:
> But, not my driver, not my decision.  Someone else can implement Michael's
> suggestion if they want.

A simpler solution could be to pass the struct usb_device_id *id to the
function af9015_read_config. There, the idVendor and idProduct are host
native...

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


