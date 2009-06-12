Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZFLWj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZFLWj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZFLWji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:39:38 -0400
Received: from tichy.grunau.be ([85.131.189.73]:38915 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZFLWjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:39:37 -0400
Date: Sat, 13 Jun 2009 00:32:55 +0200
From: Janne Grunau <j@jannau.net>
To: acpi4asus-user@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 0/2] eeepc-laptop: add 3G rfkill support for 901Go
Message-ID: <20090612223255.GD14878@aniel.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The asus_acpi module coming with the Eee PC 901 Go can turn the internal
3G modem on and off. I haven't found updated sources for it (only the
release from november 2007) but I haven't searched thoroughly nor
requested updated sources from Asus.
Adding support to eeepc-laptop looking at objdump output was easy enough
and probably faster than reply from Asus.

There remain only two little issues:
- the new values are not added to the end of the CM_ASL* enum but before
  CM_ASL_LID. I don't think it's a problem since it seems to be unused.
- The eeepc 1000HE reports 3G control support according to
  http://wiki.debian.org/DebianEeePC/Models but has no 3G modem. I assume
  this is an error in the bios.

Janne Grunau (2):
  eeepc-laptop: add 3G and Wimax CM_ASL values and acpi method names
  eeepc-laptop: add rfkill support for the 3G modem in Eee PC 901 Go

 drivers/platform/x86/eeepc-laptop.c |   62 +++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 2 deletions(-)
