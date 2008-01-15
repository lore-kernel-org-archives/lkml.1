Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYAOJv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYAOJv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYAOJvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:51:16 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59422 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYAOJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:51:15 -0500
Message-Id: <478C82BE.6040100@ce.jp.nec.com>
Date: Tue, 15 Jan 2008 18:54:06 +0900
From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [RFC] A SCSI fault injection framework using SystemTap.
References: <478C22A9.5000009@ce.jp.nec.com> <20080115033145.GR18741@parisc-linux.org>
In-Reply-To: <20080115033145.GR18741@parisc-linux.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Jan 15, 2008 at 12:04:09PM +0900, K.Tanaka wrote:
>> I would like to introduce a SCSI fault injection framework using SystemTap.
>>
>> Currently, kernel has Fault-injection framework and Faulty mode for md,
>> which can also be used for testing the error handling. But, they could
>> only produce fixed type of errors stochastically. In order to simulate
>> more realistic scsi disk faults, I have created a  new flexible fault injection
>> framework using SystemTap.
> 
> How does it compare to using scsi_debug, which I believe can do all of
> the above and more?
> 

 Sorry for the lack of explanation.
 The new framework is supposed to be used by a userspace testing tool
 (such as a shell script). For the availability, this framework enables user to
 designate the inode number of the target file on the device to inject faults.
 On accessing the target file through page caches, a fault will be injected.
 Also, user can designate the logical block address as the target position
 of a fault injection.

-- 
---------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com
