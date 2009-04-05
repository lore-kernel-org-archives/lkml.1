Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZDEHD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZDEHD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbZDEHDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:03:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46087 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZDEHDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rMpfBojCILA9y+6fJNDCHdsAZjjgYwLuPzS2FnhZ7j6dGAmJ2UjfS5JEEusZ28B1qX
         /OEw2aPGwtCHnm3i8XLWBYF9RQxt7IT2bp3mZwyXm52CanVmbp6xEqLPDUJUfc4Dn6BG
         AsZRB69CRUeyNoYNWGioKZzupJtS4zzB91/Ek=
MIME-Version: 1.0
In-Reply-To: <1238904131.4250.755.camel@haakon2.linux-iscsi.org>
References: <1238904131.4250.755.camel@haakon2.linux-iscsi.org>
Date: Sun, 5 Apr 2009 09:03:09 +0200
Message-ID: <e2e108260904050003r65a43c8cy84cf6f6e5a26bce7@mail.gmail.com>
Subject: Re: [RFC PATCH 14/19] Target_Core_Mod SCSI MIBs
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 5, 2009 at 6:02 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> This patch adds support for SCSI MIBs through /proc/scsi_target/mib following RFC-4455.

According to the Net-SNMP documentation, an implementation of the
SCSI-MIB (RFC 4455) for Linux does not yet exist
(http://www.net-snmp.org/docs/mibs/). It would be great once
implementation of this MIB starts, the kernel would offer a
well-documented interface that allows to query the information this
MIB exports. This interface can then be implemented in any SCSI target
for which these statistics are available in the kernel (SCST, IET,
LIO). This will allow a single implementation of RFC 4455 in the
Net-SNMP project instead of multiple.

The patch you posted exports the statistics needed by RFC 4455 through
a procfs interface. Sorry, but IMHO this information should be
exported in other way than through procfs.

Bart.
