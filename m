Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbYAYUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbYAYUTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYAYUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:19:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:50765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753AbYAYUT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:19:29 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: DMI: create dmi_get_slot()
Date: Fri, 25 Jan 2008 15:19:09 -0500
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20080125201357.GA3234@infomag.infomag.iguana.be>
In-Reply-To: <20080125201357.GA3234@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251519.09818.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 15:13, Wim Van Sebroeck wrote:
> Hi Len,
> 
> I saw you added the dmi_get_slot function recently.
> If I look in drivers/firmware/dmi_scan.c however I now see:
> 
> ...
> 
> /**
>  *	dmi_get_system_info - return DMI data value
>  *	@field: data index (see enum dmi_field)
>  *
>  *	Returns one DMI data value, can be used to perform
>  *	complex DMI data checks.
>  */
> const char *dmi_get_system_info(int field)
> {
> 	return dmi_ident[field];
> }
> EXPORT_SYMBOL(dmi_get_system_info);
> 
> ...
> 
> /**
>  *	dmi_get_slot - return dmi_ident[slot]
>  *	@slot:	index into dmi_ident[]
>  */
> char *dmi_get_slot(int slot)
> {
> 	return(dmi_ident[slot]);
> }
> 
> Didn't we duplicate code here?

Yep, thanks for noticing, i'll delete the duplicate.

-Len
