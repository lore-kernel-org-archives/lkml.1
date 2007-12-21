Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXLUNbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXLUNbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXLUNbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:31:37 -0500
Received: from [212.12.190.198] ([212.12.190.198]:56056 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966AbXLUNbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:31:37 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Date: Fri, 21 Dec 2007 16:30:03 +0300
User-Agent: KMail/1.5
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712211630.03426.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The current USB Kconfig menu is rather cluttered and unorganized.

Propose new layout as follows:

  lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq USB support qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk
  x  Arrow keys navigate the menu.  <Enter> selects submenus --->.  Highlighted letters  x  
  x  are hotkeys.  Pressing <Y> includes, <N> excludes, <M> modularizes features.  Press x  
  x  <Esc><Esc> to exit, <?> for Help, </> for Search.  Legend: [*] built-in  [ ]        x  
  x  excluded  <M> module  < > module capable                                            x  
  x lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk x  
  x x      --- USB support                                                             x x   
  x x      <*>   Support for Host-side USB  --->                                       x x   
  x x            USB Host Controller Drivers  --->                                     x x   
  x x            USB Device Class drivers  --->                                        x x   
  x x      ---   NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may             x x   
  x x      ---   also be needed; see USB_STORAGE Help for more information             x x   
  x x      <*>   USB Mass Storage support  --->                                        x x   
  x x      [ ]   The shared table of common (or usual) storage devices                 x x   
  x x      [ ]   USB Monitor                                                           x x   
  x x            USB Serial Converter support  --->                                    x x   
  x x            USB DSL modem support  --->                                           x x   
  x x            USB Imaging devices  --->                                             x x   
  x x            USB Miscellaneous drivers  --->                                       x x   
  x x            USB Gadget Support  --->                                              x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x x                                                                                  x x   
  x mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj x  
  tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqu  
  x                           <Select>    < Exit >    < Help >                           x  
  mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj  


Any comments appreciated.


Thanks!

--
Al
 
