Return-Path: <linux-kernel-owner+w=401wt.eu-S1750796AbXBSJhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796AbXBSJhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXBSJhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:37:07 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55898 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXBSJhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:37:06 -0500
Date: Mon, 19 Feb 2007 10:36:43 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       linux-kernel@vger.kernel.org
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <1171844733.2488.33.camel@violet>
Message-ID: <Pine.LNX.4.64.0702191031020.25686@twin.jikos.cz>
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe> 
 <45D5C789.1090607@student.ltu.se>  <8E8F647D7835334B985D069AE964A4F7028FE550@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
  <Pine.LNX.4.64.0702182216060.25686@twin.jikos.cz> <1171844733.2488.33.camel@violet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Marcel Holtmann wrote:

> we understand the original CSR HID proxy dongles, but for the Logitech 
> ones, it is wild guesses. The current support in hid2hci has been tested 
> on Logitech diNovo first generation and I have no other Logitech 
> hardware to verify it with. We might simply need the full HID report 
> descriptor to see who is at fault.

Vincent,

from the stacktrace it seems that you are using pre-2.6.20 kernel. Could 
you please compile kernel with the following changes in 
drivers/usb/input/hid-core.c

- comment the #undef DEBUG and #undef DEBUG_DATA
- add #define DEBUG and #define DEBUG_DATA

and send us the output?

-- 
Jiri Kosina
