Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYFXTNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYFXTNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYFXTN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYFXTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:13:28 -0400
Message-ID: <48614755.5080001@zytor.com>
Date: Tue, 24 Jun 2008 12:13:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Forensic File System GUID Linux/Windows
References: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> The following GUID is being used in the Wolf Mountain Group, Inc. Forensic
> File System (FFS) for GPT intel EFI partitions.  Since there is no central
> registry for EFI GUID's it is posted here for referece for folks who may
> run accross it on Windows Vista, 2003, and 2008 systems running FFS on
> Windows that may be using dual boot with Linux or vmware:
> 
> #define PARTITION_FFS_GUID \
>     EFI_GUID( 0xBEEFCAFE, 0xFEED, 0x0000, \
>               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01)
> 

You would have vastly less probability of accidental collision if you 
generated a proper random GUID, for example:

: tazenda 118 ; uuidgen -r
33ae8a9c-441e-4d97-93a3-8561388ce905

	-hpa
