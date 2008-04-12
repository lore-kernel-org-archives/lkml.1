Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYDLKfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYDLKfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbYDLKfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:35:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317AbYDLKfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=TaAin5diblLABHXhKO+RYALuWBIFDQaiIBoFMU47brQJ111ntBKtsxNuue2hHdunjdR+Uwf1iE4SdPT3VcC9u7bgqtdWCMVXCilAjpxhQ90RyGuYJWmBK1Tk1xX5OewoxaeRngTv+HY8LK+zscEKZ7vl47TSPLNDg0HIuMc3LOc=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
Date: Sat, 12 Apr 2008 12:36:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121236.38737.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This patch series (based on v2.6.25-rc8-mm2) has several improvements to
> the rfkill class that I need for thinkpad-acpi, plus two fluff and
> documentation fixes.
> 
> I'd appreciate comments, and if the patches are acceptable, that they are
> sent to mainline early during the 2.6.26 merge window.  That way, I could
> try for a thinkpad-acpi rfkill submission for 2.6.26 as well.
> 
> The thinkpad-acpi work that needs these patches is ready, and can be
> looked at on the thinkpad-acpi git tree (devel branch):
> http://repo.or.cz/w/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
> 
> Note: new thinkpads have a read-only "type any" radio switch, plus
> read-write WWAN and Bluetooth radio switches.   The embedded WLAN cards
> have WLAN read-write switches (that should be handled by the ipw* and iwl*
> drivers).  Very old thinkpads had ACPI-based WLAN radio switches, but
> thinkpad-acpi does not support those.

The following patches are fine by me, without any additional comments:
[PATCH 1/8] rfkill: clarify meaning of rfkill states
[PATCH 2/8] rfkill: fix minor typo in kernel doc
[PATCH 5/8] rfkill: add read-only rfkill switch support
[PATCH 7/8] rfkill: add an "any radio" switch type and functionality

The following patches are overall fine, but I have some additional comments:
[PATCH 6/8] rfkill: add the WWAN radio type
[PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events

The following patches are _not_ fine with me:
[PATCH 4/8] rfkill: add read-write rfkill switch support
[PATCH 8/8] rfkill: add parameter to disable radios by default

Ivo
