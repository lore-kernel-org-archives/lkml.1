Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYJUTEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYJUTEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJUTDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:03:54 -0400
Received: from kroah.org ([198.145.64.141]:60718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751126AbYJUTDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:03:54 -0400
Date: Tue, 21 Oct 2008 12:00:20 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: -git10 staging build warnings
Message-ID: <20081021190020.GA22556@kroah.com>
References: <48FE1459.5010205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FE1459.5010205@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 10:41:45AM -0700, Randy Dunlap wrote:
> x86_64:
> 
> drivers/staging/winbond/./linux/wbusb .c:109: warning: 'struct ieee80211_tx_control' declared inside parameter list drivers/staging/winbond/./linux/wbusb.c:109: warning: its scope is only this definition or declaration, which is proba bly not what you want
> drivers/staging/winbond/./linux/wbusb .c:172: warning: initialization from incompatible pointer type
> drivers/staging/winbond/./linux/wbusb .c:174: warning: initialization from incompatible pointer type
> drivers/staging/winbond/./linux/wbusb .c:180: warning: initialization from incompatible pointer type
> drivers/staging/winbond/./linux/wbusb .c:181: warning: initialization from incompatible pointer type
> drivers/staging/winbond/./linux/wbusb .c:299: warning: ISO C90 forbids mixed declarations and code
> drivers/staging/usbip/vhci_rx.c:204: warning: format '%d' expects type 'int', but argument 7 has type 'long unsigned int'
> drivers/staging/winbond/sme_api.c:13: warning: no return statement in function returning non-void

Thanks, I've now fixed these.

greg k-h
