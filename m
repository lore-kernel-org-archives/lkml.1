Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYAYUOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYAYUOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYAYUOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:14:00 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:23381 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbYAYUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:13:59 -0500
X-Belgacom-Dynamic: yes
Date: Fri, 25 Jan 2008 21:13:57 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: DMI: create dmi_get_slot()
Message-ID: <20080125201357.GA3234@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

I saw you added the dmi_get_slot function recently.
If I look in drivers/firmware/dmi_scan.c however I now see:

...

/**
 *	dmi_get_system_info - return DMI data value
 *	@field: data index (see enum dmi_field)
 *
 *	Returns one DMI data value, can be used to perform
 *	complex DMI data checks.
 */
const char *dmi_get_system_info(int field)
{
	return dmi_ident[field];
}
EXPORT_SYMBOL(dmi_get_system_info);

...

/**
 *	dmi_get_slot - return dmi_ident[slot]
 *	@slot:	index into dmi_ident[]
 */
char *dmi_get_slot(int slot)
{
	return(dmi_ident[slot]);
}

Didn't we duplicate code here?

Greetings,
Wim.

