Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbYBULdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbYBULdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759133AbYBULdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:33:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:39415 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbYBULdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=vKpiY5t5/0twPavJNbhGYqqBxUFrGweInx83pDIxtGOpH2tOa6VUCw40lNAjZ8yFUU6ipoNwx0pGyegMl7fWrnaqERt7cmTZgDdYVBw+isVVT9r2MooBfDZM4YT+Fd86sOXoJVAik7actkdHjdWPDyQI+06acBVGmiS0669qsAg=
Date: Thu, 21 Feb 2008 12:33:18 +0100
To: rpurdie@openedhand.com, rjw@sisk.pl
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: Apm_emulation and proper suspend
Message-Id: <20080221123318.41273a1f.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I'm reworking a couple of apm drivers and for whatever reason it doesn't seem to update my /proc/apm_bios. I was under the impression that it should do that when apm_bios was catted? Currently I have a value that never change. I export my get_power_status.. function properly but doesn't seem to touch it. I noticed that Richard had the extern int (void..apm_get_power) (...) declare an extra time (once in apm-emulation.h and another inside sharpsl.c), is that needed?

Also, is apm the "brains" behind the suspend/resume interactions? By that I mean, should suspend be initiated through apm functions
in order to be proper? I've tried to find examples but the best source of suspend related code is Richards code on sharp machines.

I've understod the proper way to suspend going from apm_request_suspend -> all devices suspend -> ready -> arch specific code -> off.

Best wishes
Kristoffer
