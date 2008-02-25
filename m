Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYBYSz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYBYSz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYBYSzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:55:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbYBYSzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:55:07 -0500
Date: Mon, 25 Feb 2008 10:50:57 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: Huawei E220 and usb storage
Message-Id: <20080225105057.5ea66596.zaitcev@redhat.com>
In-Reply-To: <20080220065723.GY25079@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
	<20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
	<20071030204720.GI8479@gamma.logic.tuwien.ac.at>
	<47279EF7.3040406@redhat.com>
	<20071030212213.GA13410@gamma.logic.tuwien.ac.at>
	<20071030152816.f2e8dd7c.zaitcev@redhat.com>
	<20071031061552.GH11722@gamma.logic.tuwien.ac.at>
	<20071116132256.GA19251@gamma.logic.tuwien.ac.at>
	<20080214110501.ec400e10.zaitcev@redhat.com>
	<20080220065723.GY25079@gamma.logic.tuwien.ac.at>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 07:57:23 +0100, Norbert Preining <preining@logic.at> wrote:

> > that you did, after taking care of detection and initialization.
> > Look at his dmesg in comment #44 in this:
> 
> Yes, that looks very similar.

Someone reported on the bug that a firmware update exists to resolve
the issue (version 11.117.07.00.67). Probably they started to comply
with the spec and return 12 bytes of sense according to the allocation
length in the SCSI command.
  https://bugzilla.redhat.com/show_bug.cgi?id=253096#c51

-- Pete
