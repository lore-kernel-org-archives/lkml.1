Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944Ab0ASOvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0ASOvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746Ab0ASOvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:51:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38709 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928Ab0ASOvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:51:11 -0500
X-Sasl-enc: ux2MncWc5j3Pn0ZkQFtqRFyTsv4RyYmLM547spsR7aCr 1263912670
Date: Tue, 19 Jan 2010 12:51:08 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] thinkpad-acpi: fix link error to include sound arch
Message-ID: <20100119145108.GD2668@khazad-dum.debian.net>
References: <1263820516-6924-1-git-send-email-hagen@jauu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263820516-6924-1-git-send-email-hagen@jauu.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Hagen Paul Pfeifer wrote:
> Thinkpad ACPI depends on sound for resume/suspend/shutdown
> events. This fix corrects the Kconfig dependency between

Does it?  I'd rather fix the real problem, it shouldn't depend on sound for
resume/suspend/shutdown.  If it does, the fix is to break the dependency.

> in-kernel build and module build. The preprocessor
> directive #ifdef CONFIG_THINKPAD_ACPI_ALSA_SUPPORT
> isn't sufficient to handle this build dependency.

NAK.

Can you describe the problem in more detail?  That will save me precious
time, as I am rather overworked right now...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
