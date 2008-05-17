Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbYEQWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbYEQWAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759931AbYEQWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:00:08 -0400
Received: from main.gmane.org ([80.91.229.2]:48711 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930AbYEQWAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:00:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: rt61pci breaks after hibernate
Followup-To: gmane.linux.kernel.wireless.general,gmane.linux.kernel
Date: Sat, 17 May 2008 22:54:33 +0100
Message-ID: <g0nk9b$n7v$1@ger.gmane.org>
References: <g0mqn8$56h$1@ger.gmane.org> <200805171651.56973.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

Rafael J. Wysocki wrote:

> On Saturday, 17 of May 2008, Sitsofe Wheeler wrote:
>> After resuming from a hibernate to disk network packets are no longer
>> sent and NetworkManager shows that there is no signal. Doing ifconfig
>> wlan1 down && ifconfig wlan1 up results in the error message
>> "SIOCSIFFLAGS: No such device" being printed.
> 
> Is this a regression or did it work before?

It's not a regression. It turns out I was wrong in my other comment - this
never worked. Userspace was working around the problem by unloading the
driver before hibernation and loading it back in on resume (I switched to
module free kernel a few days ago). Building a kernel that prevents module
unloading shows similar results all the way back to 2.6.25 (although the
error switches to "SIOCSIFFLAGS: No buffer space available".

-- 
Sitsofe | http://sucs.org/~sits/

