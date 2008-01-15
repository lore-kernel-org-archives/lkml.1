Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYAODcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYAODcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYAODbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:31:55 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:56543 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbYAODbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:31:47 -0500
Date: Mon, 14 Jan 2008 20:31:46 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [RFC] A SCSI fault injection framework using SystemTap.
Message-ID: <20080115033145.GR18741@parisc-linux.org>
References: <478C22A9.5000009@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478C22A9.5000009@ce.jp.nec.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 12:04:09PM +0900, K.Tanaka wrote:
> I would like to introduce a SCSI fault injection framework using SystemTap.
> 
> Currently, kernel has Fault-injection framework and Faulty mode for md,
> which can also be used for testing the error handling. But, they could
> only produce fixed type of errors stochastically. In order to simulate
> more realistic scsi disk faults, I have created a  new flexible fault injection
> framework using SystemTap.

How does it compare to using scsi_debug, which I believe can do all of
the above and more?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
