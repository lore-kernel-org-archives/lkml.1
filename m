Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZI2Kp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZI2Kp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZI2Kp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:45:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:51264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZI2Kpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:45:55 -0400
Date: Tue, 29 Sep 2009 12:46:20 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Message-ID: <20090929124620.2c8abc4d@infradead.org>
In-Reply-To: <20090929103353.GA11183@redhat.com>
References: <20090929103353.GA11183@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 12:33:53 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> This implements a minor cleanup of exported scsi headers,
> and adds export of headers that are de-facto used by userspace.
> The patches are on top of 2.6.32-rc1.
> Can these be queued for 2.6.32?
> Thanks.
> 

one of the problems I've found is that glibc has its own copy
of scsi headers, causing interesting conflicts. Do you know for
sure that with these cleanups we can retire the glibc headers?
(that would be very welcome)
If not, do you know what it would take to get to that point?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
