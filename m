Return-Path: <linux-kernel-owner+w=401wt.eu-S1751456AbZDLQPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbZDLQPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZDLQOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:14:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53931 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbZDLQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:14:52 -0400
X-Sasl-enc: g7h5+Z1vUFMPb3lv0qh9aB8jWV01u9zLFVZLWr+tKI1I 1239552891
Date: Sun, 12 Apr 2009 13:14:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
	brightness with hotkeys
Message-ID: <20090412161448.GC26502@khazad-dum.debian.net>
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411150555.8b13ed18.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009, Andrew Morton wrote:
> > With latest git kernel, I'm no longer able to control my Thinkpad (W500)
> > brightness, although I can still control the backlight, bluetooth etc.

Niels, something just occourred to me.  Is your problem the hotkeys, or the
brightness control itself?  Check /sys/class/backlight/*, please.  What do
you have in there?  Does it work?

If it is the hotkeys, make sure you either have the legacy ACPI events
enabled in kconfig, or that you have something tied to the thinkpad-acpi
input device (no, HAL doesn't do it _yet_, it just forwards the events to
X.org)...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
