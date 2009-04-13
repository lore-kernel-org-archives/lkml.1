Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZDMUfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZDMUfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZDMUez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:34:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38904 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZDMUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:34:54 -0400
X-Sasl-enc: c+y/cn6Kc5ii75a6+dmRjGOi0OmlAHM48QjvEn31eiki 1239654892
Date: Mon, 13 Apr 2009 17:34:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       mjg59@srcf.ucam.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
	brightness with hotkeys
Message-ID: <20090413203450.GC16152@khazad-dum.debian.net>
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E3575A.60204@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009, Niel Lambrechts wrote:
> >> In 2.6.29.1:
> >> lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
> >> -> ../../devices/virtual/backlight/acpi_video0

Well, that at least confirms that thinkpad-acpi doesn't have anything to
do with your troubles, you were using acpi video.

While the problem isn't fixed, you can try forcing thinkpad-acpi to
provide a backlight interface and use that (docs in
Documentation/laptops/thinkpad-acpi.txt).  But you get to keep both pieces
if that causes the kernel or X.org's GPU drivers to blow up in pieces when
the SMBIOS messes with the GPU behind their backs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
