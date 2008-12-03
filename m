Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYLCHTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYLCHTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYLCHTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:19:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:4151 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYLCHTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:19:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bQlTKcvwOv5dDW4PT3qHYnaHfsDKO9rN+6MDTewavLxgcnO2cz4F1VBMuw0z+U1bTh
         RGOw1WAkYbS6vhcSbQde5a/7jcdD+bFslWb/8Oi/SClX2m/bF6hwPpoEFF1uD8d5iT1D
         GTwawGCV0YMrytXmwvy/jGU8X+CKZ7GfkpZIo=
Message-ID: <e2e108260812022319n1b4363cai86ca0caafb5839aa@mail.gmail.com>
Date: Wed, 3 Dec 2008 08:19:38 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Subject: Re: [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct scsi_device->request_queue
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 1:49 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>  drivers/lio-core/target_core_pscsi.c |  206 +++++++++++++++++++++++++---------
>  drivers/lio-core/target_core_pscsi.h |    5 +-
>  drivers/scsi/scsi_lib.c              |    6 +-

Patches that contain changes for multiple subsystems must be split and
submitted separately. E.g. the above patch should be split in one
patch that is posted on the LIO mailing list and one patch that is
posted on the linux-scsi mailing list.

Bart.
