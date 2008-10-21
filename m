Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYJUSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYJUSLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYJUSKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:10:53 -0400
Received: from kroah.org ([198.145.64.141]:53452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752180AbYJUSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:10:52 -0400
Date: Tue, 21 Oct 2008 11:07:31 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: -git10 staging build warnings
Message-ID: <20081021180731.GA25571@kroah.com>
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
> i386:
> 
> drivers/staging/sxg/sxg.c:462: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> drivers/staging/sxg/sxg.c:479: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> drivers/staging/sxg/sxg.c:540: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> drivers/staging/sxg/sxg.c:571: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> 
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

Thanks, I have quite a few -staging patches queued up, need to ensure
these get fixed as well.

greg k-h
