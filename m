Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZLROZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZLROZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZLROZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:25:19 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37080 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbZLROZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:25:17 -0500
X-Sasl-enc: jx+CGZK6qaJ1dFIQlYIwlb7TYjCxYrkrXSVbxQgOLBKv 1261146315
Date: Fri, 18 Dec 2009 12:25:12 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linking issue with THINKPAD_ACPI=y and ALSA subsystem
Message-ID: <20091218142512.GA15898@khazad-dum.debian.net>
References: <1261103706.4041.83.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261103706.4041.83.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Marcel Holtmann wrote:
> I do have THINKPAD_ACPI=y in my configuration and CONFIG_SND=m.

That won't work.  Even with the fixes for the Kconfig (either a depends on
SND or a "select SOUND, select SND") you will have to either have both as
modules or both built-in.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
