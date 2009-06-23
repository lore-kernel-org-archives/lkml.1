Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZFWJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZFWJEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZFWJEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:04:35 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45691 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZFWJEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:04:34 -0400
Date: Tue, 23 Jun 2009 11:06:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623090654.GC19062@uranus.ravnborg.org>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Table structures must be byte-packed to match the SFI specification,
> + * as they are provided by the BIOS.
> + */
> +#pragma pack(1)
> +struct sfi_table_header {
> +	char signature[SFI_SIGNATURE_SIZE];
> +	u32 length;
> +	u8 revision;
> +	u8 checksum;
> +	char oem_id[SFI_OEM_ID_SIZE];
> +	char oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> +};
Are they endian specific?
In that case use the correct endian specific types.

Same for the other types later in this file.

	Sam
