Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYD2HsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYD2HsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYD2HsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:48:12 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:62327 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYD2HsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DFcLHU2uL0UfEm78WUtB/2P7ormTEK0WW6HNcr8+g1V5Ljv0qyrvMBDsmQ2WSrOiUkf+UrWsiUENekKjUGEagTn4DDHGmSjgtxKmtRWvmplZ+t5iImRcSH+558aeqZ+ADQ0Zs+1kaI1rrHaYY5lWzuJbVVtxX4G1cll6LLE+xRc=
Message-ID: <ed10ee420804290048pb0070ffhaf2e9dffe6868ac5@mail.gmail.com>
Date: Tue, 29 Apr 2008 00:48:11 -0700
From: "SL Baur" <steve@xemacs.org>
To: "gregkh@suse.de" <gregkh@suse.de>
Subject: Re: patch sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch added to gregkh-2.6 tree
Cc: dan.j.williams@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       hpa@zytor.com, htejun@gmail.com, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, lkml@rtr.ca, neilb@suse.de
In-Reply-To: <12094266993881@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208800267.26479.3.camel@dwillia2-linux.ch.intel.com>
	 <12094266993881@kroah.org>
X-Google-Sender-Auth: 35a9b383a2fd80fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/08, gregkh@suse.de <gregkh@suse.de> wrote:
>
>  This is a note to let you know that I've just added the patch titled
>
>      Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
>
>  to my gregkh-2.6 tree.  Its filename is
>
>      sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch

>  +       char devt_str[15];
>  +
>  +       if (kobj) {
>  +               format_dev_t(devt_str, dev->devt);

This part is ugly, but is not the fault of the patch.  The ill-
considered interface for `format_dev_t' is something that probably
noone wants to fix.

Otherwise, still OK with me.

Reviewed-by: SL Baur <steve@xemacs.org>

(Is Reviewed-by not sticky?)

-sb
