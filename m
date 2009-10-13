Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbZJMR1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbZJMR1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbZJMR1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:27:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34049 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbZJMR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:27:35 -0400
Subject: Re: [PATCH 9/12] scsi: megaraid_sas - Fix the fix for fw hang
 caused by megaraid sas application
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "Mukker, Atul" <Atul.Mukker@lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C6861E8@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119BC@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C512405@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861E8@cosmail02.lsi.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 17:26:57 +0000
Message-Id: <1255454817.2855.211.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 14:47 -0600, Yang, Bo wrote:
> RESUBMIT:
> 
> Added the fix for FW and OS hang by using MSM.  Also add the fix for pending cmd in fw, after deleting the lds.

This is practically unintelligible as a changelog.  These logs get used
by distibutions and other people trying to determine if they need the
patch based on bug reports they're seeing

>From the patch I think what you've done is:

1. Added a lock to the skinny firmware initialisation sequence to
prevent the two stage write being non atomic if multiple instances use
it.
2. Added a flag to the driver shutdown sequence to prevent aen ioctls
being called after shutdown begins.

For the future, could we also have separate bug fixes in separate
patches, please.

Also, does this need to go to stable?

Thanks,

James


