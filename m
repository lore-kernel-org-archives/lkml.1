Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYHTUtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYHTUtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYHTUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:48:57 -0400
Received: from gw.goop.org ([64.81.55.164]:36527 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbYHTUs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:48:57 -0400
Message-ID: <48AC8337.2070502@goop.org>
Date: Wed, 20 Aug 2008 13:48:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.27-rc2 USB suspend regression
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the Fedora Rawhide kernel RPM "2.6.27-0.238.rc2.fc10.i686"
(kernel-2.6.27-0.238.rc2.fc10.i686), I'm seeing suspend to ram
failures.  The suspend seems to go OK, but then I just get endless:

usb 5-1: uhci_result_common: failed with status 440000

messages, with occasional flickers of something else being printed
(perhaps).  The machine is otherwise unresponsive.

    J
